class Template < ActiveRecord::Base
  belongs_to :user
  has_many :lessons, -> { order("position ASC") }, dependent: :destroy

  validates :name, presence: true
end
