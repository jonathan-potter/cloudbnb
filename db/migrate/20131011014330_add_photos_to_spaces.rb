class AddPhotosToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :photo_url, :string
  end
end
