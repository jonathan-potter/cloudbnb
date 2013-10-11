# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

flickr = Flickr.new(key: ENV["FLICKR_KEY"], secret: ENV["FLICKR_SECRET"])

flickr_user_photos = flickr.photos.search("tags" => "selfie")
puts "FLICKR_USER_PHOTOS: #{flickr_user_photos.length}"
flickr_space_photos = flickr.photos.search("tags" => "beach house")
puts "FLICKR_SPACE_PHOTOS: #{flickr_space_photos.length}"

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