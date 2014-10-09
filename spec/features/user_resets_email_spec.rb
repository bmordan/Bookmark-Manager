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

  scenario "and is notified with an email" do
    visit '/users/reset_password'
    fill_in :email, :with => "test@test.com"
    click_on 'Reset'
    within(:css, 'h1'){
      expect(page).to have_content("We have sent an email to test@test.com with more instructions")
    }    
  end

  scenario "in a time period" do
    visit '/users/reset_password'
    fill_in :email, :with => "test@test.com"
    click_on 'Reset'
    record = User.first(:email => "test@test.com")
    expect(record.updated_at).to be_a(DateTime)   
  end

  scenario "error is raised if app can't find the user" do
    expect(lambda {visit '/users/reset_password/:EIO_WRONG_HASH_LQMQE'} ).to raise_error(RuntimeError)
  end  

  scenario "with a token" do
    user = User.first(:email => "test@test.com")
    user.update(:password_token => 'EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE')
    visit '/users/reset_password/:EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE'
    expect(page).to have_content("Choose a new password")
  end

  scenario "in a time limit of 20 mins" do
    user = User.first(:email => 'test@test.com')
    user.update(:password_token => 'EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE')
    expired = Time.local(2014,10,10,10,58,13)
    Timecop.travel(expired)
    visit '/users/reset_password/:EIOWVPUNPMEFOLQDFYXKWYCXPTCOBYLMAAJFYJULHSKZUBPYNMMDSAACRVXLQMQE'
    expect(page).to have_content("Your token has expired")
  end
end