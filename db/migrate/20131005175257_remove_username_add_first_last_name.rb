class RemoveUsernameAddFirstLastName < ActiveRecord::Migration
  def up
    remove_column :users, :username
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
  end

  def down
    add_column :users, :username, :string, null: false
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
