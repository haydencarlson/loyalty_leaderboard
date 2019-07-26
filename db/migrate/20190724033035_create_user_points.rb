class CreateUserPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :user_points do |t|
      t.integer :points
      t.integer :hours
      t.integer :rank
      t.references :user
      t.timestamps
    end
  end
end
