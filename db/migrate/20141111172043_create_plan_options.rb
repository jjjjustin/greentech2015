class CreatePlanOptions < ActiveRecord::Migration
  def change
    create_table :plan_options do |t|
      t.string :stripe_plan_id
      t.string :title
      t.integer :idea_max
      t.decimal :price

      t.timestamps
    end
  end
end
