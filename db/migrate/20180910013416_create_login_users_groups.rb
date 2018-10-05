class CreateLoginUsersGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :login_users_groups do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.timestamps
    end
  end
end
