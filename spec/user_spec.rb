require 'spec_helper'

describe User do

  params = { user: { first_name: "Applesauce",
                      last_name: "Mapplesauce",
                          email: "Applesauce.Mapplesauce@example.com",
                       password: "password",
          password_confirmation: "password" }}

  subject(:user) do
    User.create(params[:user])

    User.first
  end

  it "should store given first name" do
    expect(user.first_name).to eq(params[:user][:first_name])
  end
  it "should store given last name" do
    expect(user.last_name).to eq(params[:user][:last_name])
  end
  it "should store given email" do
    expect(user.email).to eq(params[:user][:email])
  end
  it "should not store password in plain text" do
    expect(user.password).to_not eq(nil)
  end
  it "should not store password" do
    expect(user.password).to_not eq(nil)
  end

end