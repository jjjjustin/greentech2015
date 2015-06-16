class Plan < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :stripe_customer_token, presence: true
end
