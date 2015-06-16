class StepsController < ApplicationController
  
  load_and_authorize_resource

  def show
    @step = Step.find(params[:id])
    @fields = @step.fields
    @field = Field.new
  end

  def submit
    @step = Step.find(params[:id])
    @lesson = @step.lesson
    @idea = Idea.find(params[:idea])
  end
  
  def create
    @lesson = Lesson.find(params[:step][:lesson_id])
    @step = @lesson.steps.new(step_params)

    if @step.save
      respond_to do |format|
        format.js
      end
    else
      render nothing: true
    end
  end

  def update
    @step = Step.find(params[:id])

    if params[:step] && params[:step][:responses_attributes]
      responses = true
    end

    # get old competion %
    if params[:idea]
      old_completion = Idea.find(params[:idea]).pct_complete
    end

    if params[:step] && @step.update_attributes(step_params)

      # get new completion %
      if params[:idea]
        @idea = Idea.find(params[:idea])
        new_completion = @idea.pct_complete

        # email nafasi team about completion if 100%
        if (old_completion < new_completion) && (new_completion == 100)
          Notifier.send_idea_completion_email(@idea.user, @idea).deliver
        end
      end

      if responses
        flash[:success] = "Answers saved."
      end

      respond_to do |format|
        format.html { 
          if params[:idea] && params[:step]
            if responses && @step.next_step
              redirect_to submit_step_path(@step.next_step, idea: params[:idea])
            else
              redirect_to idea_path(Idea.find(params[:idea]))
            end
          else
            redirect_to ideas_path
          end
        }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to ideas_path }
        format.js { render nothing: true }
      end
    end
  end

  def destroy
    Step.find(params[:id]).destroy
    redirect_to template_path(1)
  end

  def sort
    params[:data].each do |val|
      val.each_with_index do |step, index|
        Step.where(id: Integer(step[:id])).update_all({position: index+1})

        # update lesson id of dragged step (to handle cases of step being dragged across lessons)
        if (Integer(step[:id]) == Integer(params[:draggedStep]))
          Step.where(id: Integer(step[:id])).update_all({lesson_id: Integer(params[:lessonContainer])})
        end
      end
    end
    render nothing: true
  end

  private

    def step_params
      params.require(:step).permit!
    end

end
