class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id,         null: false
      t.integer :space_id,        null: false
      t.date    :start_date,      null: false
      t.date    :end_date,        null: false
      t.integer :approval_status, null: false
      t.float   :price,           null: false
      t.float   :service_fee,     null: false
      t.integer :guest_count,     null: false

      t.timestamps
    end

    add_index :bookings, :user_id
    add_index :bookings, :space_id
  end
end
