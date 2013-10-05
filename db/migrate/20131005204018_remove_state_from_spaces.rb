class RemoveStateFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :state
  end

  def down
    add_column :spaces, :state, :string
  end
end
