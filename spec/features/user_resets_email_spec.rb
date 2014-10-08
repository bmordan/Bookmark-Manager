require 'spec_helper'

feature "User resets their password" do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "user can be identified" do
    visit '/users/reset_password'
    fill_in :email, :with => "test@test.com"
    click_on 'Reset'
    within(:css, 'h1'){
      expect(page).to have_content("We have sent an email to test@test.com with more instructions")
    }    
  end

end