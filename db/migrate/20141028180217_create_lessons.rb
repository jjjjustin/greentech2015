class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.references :template, index: true

      t.timestamps
    end
  end
end
