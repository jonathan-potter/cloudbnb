class Space < ActiveRecord::Base
  attr_accessible :owner_id, :title, :booking_rate_daily,
  :booking_rate_weekly, :booking_rate_monthly, :residence_type, :bedroom_count,
  :bathroom_count, :room_type, :bed_type, :accommodates, :amenities, :description,
  :house_rules, :address, :city, :country, :latitude,
  :longitude, :amenities_indicies, :booking_rate_indicies, :photo_url

  geocoded_by :address

  validates_presence_of :owner_id, :title, :residence_type,
  :bedroom_count, :bathroom_count, :room_type, :bed_type, :accommodates,
  :amenities, :description, :house_rules, :address, :city, :country

  after_validation :geocode, if: :address_changed?

  has_many :space_photos
  has_many :bookings
  has_many :visitors, through: :bookings, source: :user
  belongs_to :owner,
  class_name: "User",
  foreign_key: :owner_id,
  primary_key: :id

  belongs_to :owner_photo,
  class_name: "UserPhoto",
  foreign_key: :owner_id,
  primary_key: :user_id

  def self.booking_rates
    ["Daily"]
  end

  def self.residence_types
    ["Apartment",
     "House",
     "Bed & Breakfast"]
  end

  def self.room_types
    ["Entire home/apt",
     "Private room",
     "Shared room"]
  end

  def self.bed_types
    ["Real Bed"]
  end

  def self.numerical_options
    ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16+"]
  end

  def self.amenities_list
    ["Smoking Allowed",
     "Pets Allowed",
     "TV",
     "Cable TV",
     "Internet",
     "Wireless Internet",
     "Air Conditioning",
     "Heating",
     "Elevator in Building",
     "Handicap Accessible",
     "Pool",
     "Kitchen",
     "Free parking on premise",
     "Doorman",
     "Gym",
     "Hot Tub",
     "Indoor Fireplace",
     "Buzzer/Wireless Intercom",
     "Breakfast",
     "Family/Kid Friendly",
     "Suitable for Events",
     "Washer",
     "Dryer"]
  end

  def self.integer_from_options_list(options_list)
    # convert options list given by radio buttons into one-hot integer
    amenities = 0;
    if options_list
      options_list.each do |option|
        amenities += 2 ** option.to_i
      end
    end

    amenities
  end

  def self.find_with_filters(filters)

    filtered_spaces = Space

    if filters[:city] && filters[:city].length > 0
      filtered_spaces = filtered_spaces.near(filters[:city], 30)
    end

    if filters[:room_types] && filters[:room_types].length > 0
      room_types = Space.integer_from_options_list(filters[:room_types])
      filtered_spaces = filtered_spaces.where("CAST(POW(2, room_type) AS INT) & ? > 0", room_types)
    end

    if filters[:booking_rate_min] && filters[:booking_rate_min].length > 0
      booking_rate_min = filters[:booking_rate_min]
      filtered_spaces = filtered_spaces.where("booking_rate_daily > ?", booking_rate_min)
    end

    if filters[:booking_rate_max] && filters[:booking_rate_max].length > 0
      booking_rate_max = filters[:booking_rate_max]
      filtered_spaces = filtered_spaces.where("booking_rate_daily < ?", booking_rate_max)
    end

    if filters[:guest_count] && filters[:guest_count].to_i > 0
      guest_count = filters[:guest_count]
      filtered_spaces = filtered_spaces.where("accommodates >= ?", guest_count)
    end

    if filters[:amenities]
      amenities = Space.integer_from_options_list(filters[:amenities])
      filtered_spaces = filtered_spaces.where("amenities & ? = ?", amenities, amenities)
    end

    if filters[:start_date] && filters[:start_date].length > 0
      start_date = Date.parse(filters[:start_date])
      if filters[:end_date] && filters[:end_date].length > 0
        end_date =   Date.parse(filters[:end_date])
        if start_date.is_a?(Date) && end_date.is_a?(Date)

          filtered_spaces = filtered_spaces
          .where(<<-SQL, start_date, end_date, Booking.approval_statuses[:approved])
          spaces.id NOT IN
          (SELECT bookings.space_id
             FROM bookings
            WHERE ? <= end_date AND ? >= start_date AND approval_status = ?)
          SQL

        end
      end
    end

    filtered_spaces
  end

  def self.random_space_with_photo
    SpacePhoto.where("space_id > 0").sample
  end

  def set_amenities_from_options_list!(options_list)
    self.amenities = Space.integer_from_options_list(options_list)
  end

  def set_address_given_components(street_address, city, country)
    self.address = [street_address, city, country].join(", ")
  end

  def street_address
    return nil unless @street_address || self.address

    @street_address ||= self.address.split(',').map(&:strip)
  end

  def gmaps4rails_address
    "#{self.address}, #{self.city}, #{self.country}"
  end

  def booked_dates_this_month
    bookings = Booking.where("start_date BETWEEN ? AND ?", )

    first_and_last = dates_this_month
    first = first_and_last[0]
    last  = first_and_last[1]
    bookings = Booking.where("space_id = ?"   , self.id)
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

  def dates_this_month
    day = Time.now.to_date + 1
    first_day = firstDay = day - day.day + 1

    end_day = first_day + 27
    until (end_day + 1).month != first_day.month
      end_day += 1
    end

    [first_day, end_day]
  end

  def boolean_array_from_amenities_integer
    [].tap do |amenities_list|
      Space.amenities_list.length.times do |order|
        amenities_list << (self.amenities & 2 ** order > 0)
      end
    end
  end

  def photo
    # self.photo_url || "http://placekitten.com/g/117/77"
    photo = self.space_photos.sample
    photo ? photo.url : "http://placekitten.com/g/117/77"
  end

  def photo_small
    # self.photo_url || "http://placekitten.com/g/117/77"
    photo = self.space_photos.sample
    photo ? photo.url_small : "http://placekitten.com/g/117/77"
  end

  def photo_medium
    # self.photo_url || "http://placekitten.com/g/117/77"
    photo = self.space_photos.sample
    photo ? photo.url_medium : "http://placekitten.com/g/117/77"
  end

end
