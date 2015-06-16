class PlanOptionsController < ApplicationController

  load_and_authorize_resource
  
  def index
    @plan_options = PlanOption.all
  end

  def new
    @plan_option = PlanOption.new
  end

  def create
    @plan_option = PlanOption.new(plan_option_params)

    if @plan_option.save
      redirect_to plan_options_path
    else
      render :new
    end
  end

  def edit
    @plan_option = PlanOption.find(params[:id])
  end

  def update
    @plan_option = PlanOption.find(params[:id])

    if @plan_option.update_attributes(plan_option_params)
      redirect_to plan_options_path
    else
      render :edit
    end
  end

  def destroy
    PlanOption.find(params[:id]).destroy
    redirect_to plan_options_path
  end


  private

    def plan_option_params
      params.require(:plan_option).permit(:title, :stripe_plan_id, :idea_max, :price)
    end
end
