class RemoveNullRequirementForLatLong < ActiveRecord::Migration
  def up
    change_column :spaces, :latitude, :float, :null => true
    change_column :spaces, :longitude, :float, :null => true
  end

  def down
    change_column :spaces, :latitude, :float, :null => false
    change_column :spaces, :longitude, :float, :null => false
  end

end
