class PlansController < ApplicationController

  load_and_authorize_resource

  def index
    @plan_options = PlanOption.all
    @current_plan = current_user.plan
    @no_card = false

    if @current_plan
      customer = Stripe::Customer.retrieve(@current_plan.stripe_customer_token)
      if customer.default_card.nil?
        @no_card = true
      end
    end
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user

    plan_id = params[:plan][:plan_id]

    begin
      if current_user.trial?
        customer = Stripe::Customer.create(
          :card => params[:stripe_card_token], # obtained from Stripe.js
          :plan => plan_id,
          :email => current_user.email, 
          :trial_end => (current_user.created_at + 30.days).to_i
        )
      else
        customer = Stripe::Customer.create(
          :card => params[:stripe_card_token], # obtained from Stripe.js
          :plan => plan_id,
          :email => current_user.email
        )
      end

      @plan.stripe_customer_token = customer.id
      @plan.stripe_subscription_id = customer.subscriptions.data.last.id

    rescue Stripe::StripeError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      @plan.errors.add :base, "There was a problem with your credit card."
    end

    if @plan.save
      flash[:success] = "You successfully subscribed! Welcome to nafasi."
      redirect_to root_path
    else
      flash[:danger] = "There was a problem with your card info."
      redirect_to new_plan_path(plan_id: plan_id)
    end
  end

  def update
    @plan = Plan.find(params[:id])
    new_plan_id = params[:plan][:plan_id]

    # check if a user is allowed to downgrade (require idea deletion if too many)
    current_idea_count = current_user.ideas.count
    new_plan = PlanOption.where(stripe_plan_id: new_plan_id).first
    if new_plan
      new_plan_max = new_plan.idea_max
    end
    if new_plan_max
      if current_idea_count > new_plan_max
        flash[:danger] = "You have too many active #{view_context.link_to 'ideas', ideas_path}. Delete some before downgrading."
        redirect_to plans_path
      else

        begin
          customer = Stripe::Customer.retrieve(@plan.stripe_customer_token)

          if @plan.stripe_subscription_id.blank?
            if current_user.trial?
              @plan.stripe_subscription_id = customer.subscriptions.create(:plan => new_plan_id, :trial_end => (current_user.created_at + 30.days).to_i).id
            else
              @plan.stripe_subscription_id = customer.subscriptions.create(:plan => new_plan_id).id
            end

          else
            subscription = customer.subscriptions.retrieve(@plan.stripe_subscription_id)
            subscription.plan = new_plan_id
            if current_user.trial?
              subscription.trial_end = (current_user.created_at + 30.days).to_i
            end
            subscription.save

            @plan.stripe_subscription_id = subscription.id
          end

          @plan.plan_id = new_plan_id

        rescue Stripe::StripeError => e
          logger.error "Stripe error: #{e.message}"
          @plan.errors.add :base, "There was a problem with changing subscriptions."
        end

        if @plan.save
          flash[:success] = "Your subscription has been updated."
          redirect_to plans_path
        else
          flash[:danger] = "There was a problem with changing the subscription."
          redirect_to plans_path
        end
      end

    else
      flash[:danger] = "There was a problem with changing the subscription."
      redirect_to plans_path
    end
  end

  def unsubscribe
    @plan = Plan.find(params[:plan_id])
    authorize! :unsubscribe, @plan
    
    begin
      customer = Stripe::Customer.retrieve(@plan.stripe_customer_token)
      customer.subscriptions.retrieve(@plan.stripe_subscription_id).delete

      @plan.stripe_subscription_id = ''
      @plan.plan_id = ''

    rescue Stripe::StripeError => e
      logger.error "Stripe error: #{e.message}"
      @plan.errors.add :base, "There was a problem with changing subscriptions."
    end

    if @plan.save
      flash[:success] = "You have been unsubscribed from all plans."
      redirect_to plans_path
    else
      flash[:danger] = "There was a problem unsubscribing."
      redirect_to plans_path
    end
  end

  def edit_card
    @plan = Plan.find(params[:plan_id])
    authorize! :edit_card, @plan

    customer = Stripe::Customer.retrieve(@plan.stripe_customer_token)

    unless customer.default_card.nil?
      @current_card = customer.cards.retrieve(customer.default_card)
    else
      @current_card = nil 
    end

  end

  def update_card
    @plan = Plan.find(params[:plan_id])
    authorize! :update_card, @plan

    begin
      customer = Stripe::Customer.retrieve(@plan.stripe_customer_token)
      customer.card = params[:stripe_card_token]
    
      if customer.save
        flash[:success] = "You card has been updated."
        redirect_to plans_path
      else
        flash[:danger] = "There was a problem updating your card information."
        redirect_to plan_edit_card_path(@plan)
      end

    rescue Stripe::StripeError => e
      logger.error "Stripe error: #{e.message}"
      @plan.errors.add :base, "There was a problem with changing cards."
    end
  end

  def remove_card
    @plan = Plan.find(params[:plan_id])
    authorize! :remove_card, @plan

    begin
      customer = Stripe::Customer.retrieve(@plan.stripe_customer_token)
    
      if customer.cards.retrieve(customer.default_card).delete.deleted
        flash[:success] = "Your card info has been removed."
        redirect_to plan_edit_card_path(@plan)
      else
        flash[:danger] = "There was a problem removing your card info."
        redirect_to plan_edit_card_path(@plan)
      end

    rescue Stripe::StripeError => e
      logger.error "Stripe error: #{e.message}"
      @plan.errors.add :base, "There was a problem with deleting your card."
    end
  end

  private

    def plan_params
      params.require(:plan).permit(:plan_id)
    end

end
