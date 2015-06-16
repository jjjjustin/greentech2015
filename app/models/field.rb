class Field < ActiveRecord::Base
  belongs_to :step
  acts_as_list scope: :step

  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, :reject_if => :all_blank, :allow_destroy => true

  has_many :responses
  
  validates :question, presence: true
  validates :question_type, presence: true
end
