class Lesson < ActiveRecord::Base
  belongs_to :template
  acts_as_list scope: :template
  
  has_many :steps, -> { order("position ASC") }, dependent: :destroy

  validates :title, presence: true
end
