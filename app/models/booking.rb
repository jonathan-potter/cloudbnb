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
    {canceled_by_user: -4,
    canceled_by_owner: -3,
              timeout: -2,
             declined: -1,
             unbooked:  0,
              pending:  1,
             approved:  2,
                  -4 => "canceled_by_user",
                  -3 => "canceled_by_owner",
                  -2 => "timeout",
                  -1 => "declined",
                   0 => "unbooked",
                   1 => "pending",
                   2 => "approved"}
  end

  def self.find_booking_and_update_approval_status(booking_id, method)
    booking = Booking.find_by_id(booking_id)
    booking.public_send(method)
  end

  def self.dates_this_month
    day = Time.now.to_date
    first_day = firstDay = day - day.day + 1

    end_day = first_day + 27
    until (end_day + 1).month != first_day.month
      end_day += 1
    end

    [first_day, end_day]
  end

  def self.booked_dates_this_month_for_space(space)
    bookings = Booking.where("start_date BETWEEN ? AND ?", )

    first_and_last = self.dates_this_month
    first = first_and_last[0]
    last  = first_and_last[1]
    bookings = Booking.where("space_id = ?"   , space.id)
                      .where("? < end_date"  , first)
                      .where("? >= start_date", last)
                      .where("approval_status = ?"     , Booking.approval_statuses[:approved])

    booked_dates = Set.new
    days = (first..last).to_a
    bookings.each do |booking|
      days.each do |day|
        booked_dates << day if day.between?(booking.start_date, booking.end_date - 1)
      end
    end

    booked_dates
  end

  def conflicts_with_date?(date)
    date.between(self.start_date, self.end_date)
  end

  def set_approval_status(status)
    self.update_attributes!(approval_status: status)
  end

  def overlapping_requests(status)
    Booking
    .where("space_id = ?"        , self.space_id)
    .where("? < end_date"       , self.start_date)
    .where("? >= start_date"     , self.end_date)
    .where("id != ?"             , self.id)
    .where("approval_status = ?" , Booking.approval_statuses[status])
  end

  def decline_conflicting_pending_requests!
    overlapping_requests(:pending).each { |request| request.decline }
  end

  def cancel_by_user
    self.set_approval_status(Booking.approval_statuses[:canceled_by_user])
  end

  def cancel_by_owner
    self.set_approval_status(Booking.approval_statuses[:canceled_by_owner])
  end

  def decline
    self.set_approval_status(Booking.approval_statuses[:declined])
  end

  def book
    unless overlapping_requests(:approved)
      self.set_approval_status(Booking.approval_statuses[:pending])
    end
  end

  def approve
    self.set_approval_status(Booking.approval_statuses[:approved])
    self.decline_conflicting_pending_requests!
  end

end
