class RemoveNullRequirementForPrices < ActiveRecord::Migration
  def up
    change_column :spaces, :booking_rate_daily, :integer, :null => true
    change_column :spaces, :booking_rate_weekly, :integer, :null => true
    change_column :spaces, :booking_rate_monthly, :integer, :null => true
  end

  def down
    change_column :spaces, :booking_rate_daily, :integer, :null => false
    change_column :spaces, :booking_rate_weekly, :integer, :null => false
    change_column :spaces, :booking_rate_monthly, :integer, :null => false
  end
end
