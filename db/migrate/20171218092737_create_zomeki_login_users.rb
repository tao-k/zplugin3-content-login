class CreateZomekiLoginUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :login_users do |t|
      t.integer :content_id
      t.string :state
      t.string :account
      t.string :password
      t.string :remember_token
      t.datetime "remember_token_expires_at"
      t.timestamps
    end
  end
end
