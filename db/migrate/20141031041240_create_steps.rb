class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.references :lesson, index: true

      t.timestamps
    end
  end
end
