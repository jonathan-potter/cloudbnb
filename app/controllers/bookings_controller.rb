class BookingsController < ApplicationController

  def index
    if params[:space_id]
      @space = Space.find_by_id(params[:space_id])
      @bookings = @space.bookings
      @visitors = @space.visitors

      render html: "bookings/index/space"
    elsif params[:user_id]
      @user = User.find_by_id(params[:user_id])

      render html: "bookings/index/user"
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

  def update
    @booking = Booking.find(params[:id])
    @booking.approval_status = Booking.approval_statuses[:pending]

    if @booking.save
      redirect_to @booking
    else
      render status: 422
    end
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

end
