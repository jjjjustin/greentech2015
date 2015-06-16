class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user, index: true
      t.string :profession
      t.string :linkedin
      t.string :location

      t.timestamps
    end
  end
end
