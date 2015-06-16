class TemplatesController < ApplicationController

  def index
    @templates = current_user.templates
  end

  def show
    @template = Template.find(params[:id])

    @lessons = @template.lessons
    @lesson = Lesson.new

    @step = Step.new
  end

end
