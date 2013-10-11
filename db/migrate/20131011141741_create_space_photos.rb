class CreateSpacePhotos < ActiveRecord::Migration
  def change
    create_table :space_photos do |t|
      t.integer :space_id
      t.string  :url,               null: false
      t.string  :flickr_title,      null: false
      t.string  :flickr_owner_name, null: false

      t.timestamps
    end

    add_index  :space_photos, :space_id
    add_column :spaces, :space_photo_id, :integer
  end
end
