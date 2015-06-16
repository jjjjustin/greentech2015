class PlanOption < ActiveRecord::Base
  validates :stripe_plan_id, presence: true
  validates :title, presence: true
  validates :idea_max, presence: true
  validates :price, presence: true
end
