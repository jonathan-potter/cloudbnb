class CreateUserPhotos < ActiveRecord::Migration
  def change
    create_table :user_photos do |t|
      t.integer :user_id
      t.string  :url,               null: false
      t.string  :flickr_title,      null: false
      t.string  :flickr_owner_name, null: false

      t.timestamps
    end

    add_index  :user_photos, :user_id
    add_column :users, :user_photo_id, :integer
  end
end
