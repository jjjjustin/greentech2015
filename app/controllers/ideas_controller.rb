class IdeasController < ApplicationController

  load_and_authorize_resource
  
  def index
    @ideas = current_user.ideas
  end

  def show
    @idea = Idea.find(params[:id])

    # # if user's trial has expired
    # if @idea.user.trial? == false

    #   # check if he has a plan obj
    #   current_plan = @idea.user.plan
    #   if current_plan
    #     # check if they have a paid plan, redirect if they dont
    #     if current_plan.plan_id.blank?
    #       flash[:danger] = "Please #{view_context.link_to 'subscribe', plans_path} to a plan to access existing ideas."
    #       redirect_to plans_path
    #     end
    #   else
    #     # redirect if their trial has expired and no plan obj
    #     flash[:danger] = "Please #{view_context.link_to 'subscribe', plans_path} to a plan to access existing ideas."
    #     redirect_to plans_path
    #   end
    # end

    @template = Template.first
  end

  def show_admin
    @idea = Idea.find(params[:idea_id])
    @user = User.find(@idea.user_id)
    @template = Template.first
  end

  def new
    # if current_user.plan_capacity?
      @idea = Idea.new
    # else
    #   flash[:danger] = "Please #{view_context.link_to 'subscribe or upgrade', plans_path} your plan before creating more ideas."
    #   redirect_to ideas_path
    # end
  end

  def create
    # if current_user.plan_capacity?
      @idea = Idea.new(idea_params)
      @idea.user = current_user

      if @idea.save
        redirect_to idea_path(@idea)
      else
        render :new
      end
    # else
    #   flash[:danger] = "Please #{view_context.link_to 'subscribe or upgrade', plans_path} your plan before creating more ideas."
    #   redirect_to ideas_path
    # end

  end

  def edit
    @idea = Idea.find(params[:id])
  end

  def update
    @idea = Idea.find(params[:id])

    if @idea.update_attributes(idea_params)
      redirect_to ideas_path
    else
      render :edit
    end
  end

  def destroy
    Idea.find(params[:id]).destroy
    redirect_to ideas_path
  end


  private

    def idea_params
      params.require(:idea).permit(:name, :description)
    end
end
