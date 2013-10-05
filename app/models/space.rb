class Space < ActiveRecord::Base
  attr_accessible :somanythings
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

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

  def self.accommodates_list
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
end
