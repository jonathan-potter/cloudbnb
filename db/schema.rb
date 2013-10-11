# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131011174832) do

  create_table "bookings", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.integer  "space_id",           :null => false
    t.date     "start_date",         :null => false
    t.date     "end_date",           :null => false
    t.integer  "approval_status",    :null => false
    t.float    "service_fee",        :null => false
    t.integer  "guest_count",        :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.float    "total"
    t.float    "booking_rate_daily"
  end

  add_index "bookings", ["space_id"], :name => "index_bookings_on_space_id"
  add_index "bookings", ["user_id"], :name => "index_bookings_on_user_id"

  create_table "space_photos", :force => true do |t|
    t.integer  "space_id"
    t.string   "url",                            :null => false
    t.string   "flickr_title",                   :null => false
    t.string   "flickr_owner_name",              :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "flickr_id",         :limit => 8, :null => false
  end

  add_index "space_photos", ["flickr_id"], :name => "index_space_photos_on_flickr_id"
  add_index "space_photos", ["space_id"], :name => "index_space_photos_on_space_id"

  create_table "spaces", :force => true do |t|
    t.integer  "owner_id",             :null => false
    t.string   "title",                :null => false
    t.integer  "booking_rate_daily"
    t.integer  "booking_rate_weekly"
    t.integer  "booking_rate_monthly"
    t.integer  "residence_type",       :null => false
    t.integer  "bedroom_count",        :null => false
    t.integer  "bathroom_count",       :null => false
    t.integer  "room_type",            :null => false
    t.integer  "bed_type",             :null => false
    t.integer  "accommodates",         :null => false
    t.integer  "amenities",            :null => false
    t.text     "description",          :null => false
    t.text     "house_rules",          :null => false
    t.string   "address",              :null => false
    t.string   "city",                 :null => false
    t.string   "country",              :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "photo_url"
    t.integer  "space_photo_id"
  end

  add_index "spaces", ["booking_rate_daily"], :name => "index_spaces_on_booking_rate_daily"
  add_index "spaces", ["booking_rate_monthly"], :name => "index_spaces_on_booking_rate_monthly"
  add_index "spaces", ["booking_rate_weekly"], :name => "index_spaces_on_booking_rate_weekly"
  add_index "spaces", ["latitude"], :name => "index_spaces_on_latitude"
  add_index "spaces", ["longitude"], :name => "index_spaces_on_longitude"
  add_index "spaces", ["owner_id"], :name => "index_spaces_on_owner_id"

  create_table "user_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "url",                            :null => false
    t.string   "flickr_title",                   :null => false
    t.string   "flickr_owner_name",              :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "flickr_id",         :limit => 8, :null => false
  end

  add_index "user_photos", ["flickr_id"], :name => "index_user_photos_on_flickr_id"
  add_index "user_photos", ["user_id"], :name => "index_user_photos_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "first_name",      :null => false
    t.string   "last_name",       :null => false
    t.string   "session_token"
    t.string   "photo_url"
    t.integer  "user_photo_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
