# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


######################### Grab Photos From Flickr ##############################

user_photo_limit = ENV["SEED_PHOTO_LIMIT"].to_i
space_photo_limit = ENV["SEED_PHOTO_LIMIT"].to_i

flickr = Flickr.new(key: ENV["FLICKR_KEY"], secret: ENV["FLICKR_SECRET"])

if UserPhoto.all.length.to_i < user_photo_limit.to_i

  flickr_user_photos = flickr.photos.search("tags" => ENV["SEED_USER_SEARCH_TERM"])
  puts "FLICKR_USER_PHOTOS: #{flickr_user_photos.length}"

else

  flickr_user_photos = []
  puts "NO NEW FLICKR_USER_PHOTOS NEEDED"

end

if SpacePhoto.all.length.to_i < space_photo_limit.to_i

  flickr_space_photos = flickr.photos.search("tags" => ENV["SEED_SPACE_SEARCH_TERM"])
  puts "FLICKR_SPACE_PHOTOS: #{flickr_space_photos.length}"

else

  flickr_space_photos = []
  puts "NO NEW FLICKR_SPACE_PHOTOS NEEDED"

end

######################### Put Photos in the Database ###########################

flickr_user_photos.each do |photo|
  user_photo                   = UserPhoto.new
  user_photo.url               = photo.url
  user_photo.flickr_id         = photo.id.to_i
  user_photo.flickr_title      = photo.title
  user_photo.flickr_owner_name = photo.owner_name

  user_photo.save
end

flickr_space_photos.each do |photo|
  space_photo                   = SpacePhoto.new
  space_photo.url               = photo.url
  space_photo.flickr_id         = photo.id.to_i
  space_photo.flickr_title      = photo.title
  space_photo.flickr_owner_name = photo.owner_name

  space_photo.save
end

######################### Seed Database with Users #############################

user_limit = ENV["SEED_USER_LIMIT"].to_i
space_limit = ENV["SEED_SPACE_LIMIT"].to_i

if User.all.length < user_limit.to_i

  user_count = User.all.length
  (user_limit - user_count).times do |user_index|

    user_hash = {}

    user_hash[:first_name]            = Faker::Name.first_name
    user_hash[:last_name]             = Faker::Name.last_name
    user_hash[:email]                 = "user#{user_count + user_index + 1}@example.com"
    user_hash[:password]              = "password"
    user_hash[:password_confirmation] = "password"

    User.create(user_hash)
  end

end

if Space.all.length < space_limit.to_i

  space_count = Space.all.length
  (space_limit - space_count).times do |user_index|

    space_hash = {}

    address = Faker::Address.name.split(" ")

    space_hash[:owner_id]              = User.first(:order => "RANDOM()").id
    space_hash[:title]                 = Faker::Company.catch_phrase
    space_hash[:booking_rate_daily]    = rand(200)
    space_hash[:residence_type]        = rand(Space.residence_types.length)
    space_hash[:bedroom_count]         = rand(5 + 1)
    space_hash[:bathroom_count]        = rand(3 + 1)
    space_hash[:room_type]             = rand(Space.room_types.length)
    space_hash[:bed_type]              = rand(Space.bed_types.length)
    space_hash[:accommodates]          = rand(6 + 1)
    space_hash[:amenities]             = rand(2 ** Space.amenities_list.length)
    space_hash[:description]           = Faker::Company.catch_phrase
    space_hash[:house_rules]           = Faker::Company.catch_phrase
    space_hash[:address]               = "#{(rand(125) + 1).ordinalize} and #{(rand(10) + 1).ordinalize}"
    space_hash[:city]                  = ENV["SEED_CITY"]
    space_hash[:country]               = ENV["SEED_COUNTRY"]

    Space.create(space_hash)
    sleep(0.25)
  end

end

################# Associate Users/Spaces with Random Photos ####################

User.all.each do |user|
  unless user.user_photos.length > 0
    photos = UserPhoto.where("user_id IS NULL")
    if photos.length > 0
      photo = photos.sample
      photo.update_attributes(user_id: user.id)
    end
  end
end

Space.all.each do |space|
  unless space.space_photos.length > 0
    photos = SpacePhoto.where("space_id IS NULL")
    if photos.length > 0
      photo = photos.sample
      photo.update_attributes(space_id: space.id)
    end
  end
end

