require 'spec_helper'

feature "User resets their password" do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
    time = Time.local(2014,10,10,10,32,45) # time at 10:32am
    Timecop.freeze(time)
    stub_request(:post, "https://api:key-7577f504028fa8de43dc70aea8bdb787@api.mailgun.net/v2/app30532338.mailgun.org/messages").with(:body => /.+/)
  end

  scenario "user can enter email and be identified" do
    visit '/users/reset_password'
    fill_in :email, :with => "test@test.com"
    click_on 'Reset'
    within(:css, 'h1'){
      expect(page).to have_content("We have sent an email to test@test.com with more instructions")
    }    
  end

  scenario "user has a time period for a password reset" do
    visit '/users/reset_password'
    fill_in :email, :with => "test@test.com"
    click_on 'Reset'
    record = User.first(:email => "test@test.com")
    expect(record.updated_at).to be_a(DateTime)   
  end

  scenario "with an email reset link" do

    visit '/users/reset_password'
    fill_in :email, :with => "test@test.com"
    click_on 'Reset'

  end

  scenario "user has a token" do
    user = User.first(:email => "test@test.com")
    user.update(:password_token => 'EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE')
    visit '/users/reset_password/EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE'
    expect(page).to have_content("Choose a new password")
  end

  scenario "user's token time limit of 20 mins has expired" do
    user = User.first(:email => 'test@test.com')
    user.update(:password_token => 'EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE')
    expired = Time.local(2014,10,10,10,58,13)
    Timecop.travel(expired)
    visit '/users/reset_password/EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE'
    expect(page).to have_content("Your token has expired")
  end
end