class CreateLoginGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :login_groups do |t|
      t.integer :content_id
      t.string :state
      t.string :name
      t.string :title
      t.timestamps
    end
  end
end
