class SpacesController < ApplicationController

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(params[:space])
    @space.owner_id = current_user.id
    @space.set_amenities_from_options_list!(params[:space_amenities_indicies])
    @space.set_booking_rates_from_options_list!(params[:space_booking_rates_indicies])

    @space.set_address_given_components(@space.address,
                                        @space.city,
                                        @space.country)

    if @space.save!
      redirect_to @space
    else
      flash.now[:errors] << @space.errors
      render :new
    end
  end

  def show
    @space = Space.find(params[:id])
  end

end
