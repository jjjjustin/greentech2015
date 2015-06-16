class Step < ActiveRecord::Base
  belongs_to :lesson
  acts_as_list scope: :lesson

  has_many :fields, -> { order("position ASC") }, dependent: :destroy
  accepts_nested_attributes_for :fields

  has_many :responses
  accepts_nested_attributes_for :responses, reject_if: proc { |attributes| attributes['value'].blank? }

  validates :title, presence: true

  def next_step
    lesson = self.lesson
    next_step = Step.where(lesson_id: lesson.id, position: self.position+1).first
    
    # if there is a next step within the current lesson
    if next_step
      return next_step
    else
      # otherwise go to the next lesson
      next_lesson = Lesson.where(template_id: lesson.template_id, position: lesson.position+1).first

      if next_lesson

        # if the next lesson has steps return the first
        if next_lesson.steps.first
          return next_lesson.steps.first

        # if there are no steps in the next lesson
        else
          return nil
        end

      # if there is no next lesson
      else
        return nil
      end
    end
  end

  def prev_step
    lesson = self.lesson
    prev_step = Step.where(lesson_id: lesson.id, position: self.position-1).first
    
    # if there is a previous step within the current lesson
    if prev_step
      return prev_step
    else
      # otherwise go to the previous lesson
      prev_lesson = Lesson.where(template_id: lesson.template_id, position: lesson.position-1).first

      if prev_lesson

        # if the previous lesson has steps return the first
        if prev_lesson.steps.last
          return prev_lesson.steps.last

        # if there are no steps in the previous lesson
        else
          return nil
        end

      # if there is no previous lesson
      else
        return nil
      end
    end
  end

end
