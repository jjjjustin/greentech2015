class Response < ActiveRecord::Base
  belongs_to :field
  belongs_to :step
  belongs_to :idea

  validates :value, presence: true

  serialize :value
end
