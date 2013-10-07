class BookingsController < ApplicationController

  def index
  end

  def show
  end

  def new
    @booking = Booking.new(params[:booking])
    @space = Space.find_by_id(params[:space_id])
  end

  def create
  end

end
