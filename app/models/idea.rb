class Idea < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true

  has_many :responses, dependent: :destroy

  def pct_complete
    total_question_count = Field.all.count
    idea_progress_count = self.responses.where(active: true).count

    if total_question_count == 0
      return 100
    else
      percentage = idea_progress_count.to_f / total_question_count.to_f * 100

      if percentage > 100
        return 100
      else
        return percentage.to_i
      end
    end
  end

end
