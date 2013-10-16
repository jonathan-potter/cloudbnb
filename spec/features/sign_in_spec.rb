require 'capybara/rspec'

describe "the signin process", :type => :feature do

  params = { valid_user: { first_name: "Applesauce",
                            last_name: "Mapplesauce",
                                email: "Applesauce.Mapplesauce@example.com",
                             password: "password",
                password_confirmation: "password" }}

  before :each do
    User.create(params[:valid_user])
  end

  it "signs me in" do
    visit '/session/new'
    within("#new-session-form") do
      fill_in 'user[email]', :with => params[:valid_user][:email]
      fill_in 'user[password]', :with => params[:valid_user][:password]
    end

    click_button "Sign in"

    expect(current_path).to eq('/spaces')
  end
end