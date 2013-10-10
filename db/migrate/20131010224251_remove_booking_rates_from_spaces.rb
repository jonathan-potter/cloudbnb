class RemoveBookingRatesFromSpaces < ActiveRecord::Migration
  def up
    remove_column :spaces, :booking_rates
  end

  def down
    add_column :spaces, :booking_rates, :integer, null: false
  end
end
