class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|

      t.integer :owner_id,             null: false
      t.string  :title,                null: false
      t.integer :booking_rates,        null: false
      t.float   :booking_rate_daily,   null: false
      t.float   :booking_rate_weekly,  null: false
      t.float   :booking_rate_monthly, null: false

      t.integer :residence_type,       null: false
      t.integer :bedroom_count,        null: false
      t.integer :bathroom_count,       null: false

      t.integer :room_type,            null: false
      t.integer :bed_type,             null: false
      t.integer :accommodates,         null: false
      t.integer :amenities,            null: false
      t.text    :description,          null: false
      t.text    :house_rules,          null: false

      t.string  :address,              null: false
      t.string  :city,                 null: false
      t.string  :state,                null: false
      t.string  :country,              null: false

      t.float   :latitude,             null: false
      t.float   :longitude,            null: false

      t.timestamps
    end

    add_index :spaces, :owner_id
    add_index :spaces, :booking_rate_daily
    add_index :spaces, :booking_rate_weekly
    add_index :spaces, :booking_rate_monthly

  end
end
