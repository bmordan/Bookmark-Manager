require 'spec_helper'

describe User do
  let(:user) {User.new()}

  it "should generate a password token for a password reset" do
    expect(user.password_token).to be_a(String)
  end
end