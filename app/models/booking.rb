class Booking < ActiveRecord::Base
  attr_accessible :user_id, :space_id, :start_date, :end_date,
                  :approval_status, :price, :service_fee, :guest_count

  validates_presence_of  :user_id, :space_id, :start_date, :end_date,
                         :approval_status, :price, :service_fee, :guest_count

  belongs_to :user
  belongs_to :space

end
