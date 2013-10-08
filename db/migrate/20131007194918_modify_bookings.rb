class ModifyBookings < ActiveRecord::Migration
  def up
    add_column    :bookings, :total, :float
    add_column    :bookings, :booking_rate_daily, :float
    remove_column :bookings, :price
  end

  def down
    remove_column :bookings, :total
    remove_column :bookings, :booking_rate_daily
    add_column    :bookings, :price, :float
  end
end
