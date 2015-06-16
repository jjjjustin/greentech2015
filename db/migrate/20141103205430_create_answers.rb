class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :value
      t.references :field, index: true

      t.timestamps
    end
  end
end
