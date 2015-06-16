class Answer < ActiveRecord::Base
  belongs_to :field

  validates :value, presence: true
end
