class AddFlickrPhotoIdToPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :flickr_id, :bigint, null: false, unique: true
    add_column :space_photos, :flickr_id, :bigint, null: false, unique: true

    add_index :user_photos, :flickr_id
    add_index :space_photos, :flickr_id
  end
end
