class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :twitch_name
      t.date :token_expires_at
      t.string :user_token
      t.timestamps
    end
  end
end
