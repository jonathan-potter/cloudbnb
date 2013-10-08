class Space < ActiveRecord::Base
  attr_accessible :owner_id, :title, :booking_rates, :booking_rate_daily,
  :booking_rate_weekly, :booking_rate_monthly, :residence_type, :bedroom_count,
  :bathroom_count, :room_type, :bed_type, :accommodates, :amenities, :description,
  :house_rules, :address, :city, :country, :latitude,
  :longitude, :amenities_indicies, :booking_rate_indicies

  geocoded_by :address
  acts_as_gmappable process_geocoding: false

  validates_presence_of :owner_id, :title, :booking_rates, :residence_type,
  :bedroom_count, :bathroom_count, :room_type, :bed_type, :accommodates,
  :amenities, :description, :house_rules, :address, :city, :country

  after_validation :geocode, if: :address_changed?


  has_many :bookings
  has_many :visitors, through: :bookings, source: :user
  belongs_to :owner,
  class_name: "User",
  foreign_key: :owner_id,
  primary_key: :id


  def self.booking_rates
    ["Daily",
     "Weekly",
     "Monthly"]
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
      filtered_spaces = filtered_spaces.near(filters[:city],10)
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

    if filters[:amenities]
      amenities = Space.integer_from_options_list(filters[:amenities])
      filtered_spaces = filtered_spaces.where("amenities & ? = ?", amenities, amenities)
    end

    filtered_spaces == Space ? Space.all : filtered_spaces
  end

  def set_amenities_from_options_list!(options_list)
    self.amenities = Space.integer_from_options_list(options_list)
  end

  def set_booking_rates_from_options_list!(options_list)
    self.booking_rates = Space.integer_from_options_list(options_list)
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

end
