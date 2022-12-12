require 'rails_helper'

RSpec.describe 'User Login' do

  before :each do
    @user = User.create!(name: 'Watson', email: 'watson@sleuth.com', password: 'password')
    visit '/login'
  end

  describe 'as a registered user' do
    it "when I enter my unique email and correct password I'm taken to my
    dashboard page" do
      fill_in "email", with: "watson@sleuth.com"
      fill_in "password", with: "password"

      click_button 'Login'

      expect(current_path).to eq(user_path(@user))
    end

    it 'when I enter an invalid password/email I am taken back to the login page
    where I see an error' do
      fill_in "email", with: "watson@sleuth.com"
      fill_in "password", with: "password111"

      click_button 'Login'

      expect(current_path).to eq('/login')
      expect(page).to have_content('Invalid email/password')
    end
  end
end