class LessonsController < ApplicationController

  load_and_authorize_resource
  
  def create
    @template = Template.find(params[:lesson][:template_id])
    @lesson = @template.lessons.new(lesson_params)

    if @lesson.save
      @step = Step.new
      respond_to do |format|
        format.js
      end
    else
      render nothing: true
    end
  end

  def update
    @lesson = Lesson.find(params[:id])

    if @lesson.update_attributes(lesson_params)
      respond_to do |format|
        format.js
      end
    else
      render nothing: true
    end
  end

  def destroy
    Lesson.find(params[:id]).destroy
    redirect_to template_path(1)
  end

  def sort
    params[:data].each_with_index do |lesson, index|
      Lesson.where(id: Integer(lesson[:id])).update_all({position: index+1})
    end

    render nothing: true
  end

  private

    def lesson_params
      params.require(:lesson).permit(:title, :description)
    end

end
