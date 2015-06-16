class FieldsController < ApplicationController

  load_and_authorize_resource
  
  def create
    @step = Step.find(params[:field][:step_id])
    @field = @step.fields.new(field_params)

    if @field.save
      respond_to do |format|
        format.js
      end
    else
      render nothing: true
    end
  end

  def update
    @field = Field.find(params[:id])
    @step = @field.step
    
    if @field.update_attributes(field_params)
      respond_to do |format|
        format.js
      end
    else
      render nothing: true
    end
  end

  def destroy
    @field = Field.find(params[:id])
    @step = @field.step

    # make all responses to this question inactive
    @field.responses.each do |response|
      response.active = false
      response.save
    end

    Field.find(params[:id]).destroy
    redirect_to @step
  end

  def sort
    params[:data].each_with_index do |field, index|
      Field.where(id: Integer(field[:id])).update_all({position: index+1})
    end

    render nothing: true
  end

  private

    def field_params
      params.require(:field).permit(:question, :question_type, answers_attributes: [:id, :value, :_destroy])
    end
end