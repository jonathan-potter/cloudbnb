class BookingsController < ApplicationController

  before_filter :require_current_user!

  def index
    if params[:space_id]
      @space = Space.find_by_id(params[:space_id])

      if @space.owner.id == current_user.id
        redirect_to "http://slashdot.com"
      else
        render "bookings/index/space"
      end
    else
      @user = User.find_by_id(current_user.id)

      render "bookings/index/user"
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @space = Space.find_by_id(@booking.space_id)
  end

  def edit
    @booking = Booking.find(params[:id])
    @space = Space.find_by_id(params[:space_id])
  end

  def create
    @booking = Booking.new(params[:booking])
    @space = Space.find_by_id(@booking.space_id)

    @booking.user_id            = current_user.id
    @booking.booking_rate_daily = @space.booking_rate_daily
    @booking.approval_status    = Booking.approval_statuses[:unbooked]

    night_count = @booking.end_date - @booking.start_date
    subtotal    = night_count * @booking.booking_rate_daily

    @booking.service_fee        = subtotal * 0.10

    @booking.total              = subtotal + @booking.service_fee

    if @booking.save
      redirect_to edit_space_booking_url(@space.id, @booking.id)
    else
      render status: 422
    end
  end

############## Below actions only modify booking approval status ###############

  def cancel_by_user
    Booking.find_booking_and_update_approval_status(params[:id], "cancel_by_user")
    redirect_to(:back)
  end

  def cancel_by_owner
    Booking.find_booking_and_update_approval_status(params[:id], "cancel_by_owner")
    redirect_to(:back)
  end

  def decline
    Booking.find_booking_and_update_approval_status(params[:id], "decline")
    redirect_to(:back)
  end

  def book
    Booking.find_booking_and_update_approval_status(params[:id], "book")
    redirect_to(:back)
  end

  def approve
    Booking.find_booking_and_update_approval_status(params[:id], "approve")
    redirect_to(:back)
  end

end