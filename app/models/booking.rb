class Booking < ActiveRecord::Base
  attr_accessible :user_id, :space_id, :start_date, :end_date,
                  :approval_status, :total, :service_fee,
                  :booking_rate_daily, :guest_count

  validates_presence_of :user_id, :space_id, :start_date, :end_date,
                        :approval_status, :total, :service_fee,
                        :booking_rate_daily, :guest_count

  belongs_to :user
  belongs_to :space

  def self.approval_statuses
    { timeout: -2,
     declined: -1,
     unbooked:  0,
      pending:  1,
     approved:  2,
          -2 => "timeout",
          -1 => "declined",
           0 => "unbooked",
           1 => "pending",
           2 => "approved"}
  end

end
