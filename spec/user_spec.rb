require 'spec_helper'

describe User do

  params = { valid_user: { first_name: "Applesauce",
                            last_name: "Mapplesauce",
                                email: "Applesauce.Mapplesauce@example.com",
                             password: "password",
                password_confirmation: "password" }}

  subject(:user) do
    User.create(params[:valid_user])

    User.last
  end

  describe "stored in the database" do
    it "should have a first name" do
      expect(user.first_name).to eq(params[:valid_user][:first_name])
    end
    it "should have a last name" do
      expect(user.last_name).to eq(params[:valid_user][:last_name])
    end
    it "should have an email" do
      expect(user.email).to eq(params[:valid_user][:email])
    end
    it "should not have it's password in plain text" do
      expect(user.password).to eq(nil)
    end
  end


end