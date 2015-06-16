class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.text :question
      t.integer :position
      t.string :question_type
      t.references :step, index: true

      t.timestamps
    end
  end
end
