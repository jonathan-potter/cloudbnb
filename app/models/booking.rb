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

  ############# BOOKING COST CALCULATIONS ###################################

  def night_count
    (self.end_date - self.start_date).to_i
  end

  def subtotal
    self.booking_rate_daily * self.night_count
  end

  def service_fee
    self.subtotal * 0.10
  end

  def total
    self.subtotal + self.service_fee
  end

  ############# VALIDATING BOOKING PARAMETERS ###############################

  def guest_count_valid?
    self.guest_count < self.space.accommodates
  end

  def conflicts_with_date?(date)
    date.between(self.start_date, self.end_date)
  end

  def conflicts_with_dates?(start_date, end_date)
    self.start_date < end_date && self.end_date > start_date
  end

  def has_initial_form_attributes
    self.start_date && self.end_date && self.guest_count
  end

  def overlapping_requests(status)
    Booking
    .where("space_id = ?"        , self.space_id)
    .where("? < end_date"       , self.start_date)
    .where("? >= start_date"     , self.end_date)
    .where("id != ?"             , self.id)
    .where("approval_status = ?" , Booking.approval_statuses[status])
  end

  def is_free_of_conflicts?
    overlapping_requests(:approved).empty?
  end

  ############# UPDATING BOOKING PARAMETERS #################################

  def update_approval_status(method)
    self.public_send(method)
  end

  def set_approval_status(status)
    self.update_attributes!(approval_status: status)
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
    if overlapping_requests(:approved).empty?
      self.set_approval_status(Booking.approval_statuses[:pending])
    end
  end

  def approve
    self.set_approval_status(Booking.approval_statuses[:approved])
    self.decline_conflicting_pending_requests!
  end

end
