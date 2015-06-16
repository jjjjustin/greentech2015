class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :stripe_customer_token
      t.string :stripe_subscription_id
      t.string :plan_id
      t.references :user, index: true

      t.timestamps
    end
  end
end
