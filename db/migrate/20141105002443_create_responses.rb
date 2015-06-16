class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :value
      t.boolean :active, default: true
      t.references :field, index: true
      t.references :step, index: true
      t.references :idea, index: true

      t.timestamps
    end
  end
end
