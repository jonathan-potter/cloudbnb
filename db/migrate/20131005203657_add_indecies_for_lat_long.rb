class AddIndeciesForLatLong < ActiveRecord::Migration
  def change
    add_index :spaces, :latitude
    add_index :spaces, :longitude
  end
end
