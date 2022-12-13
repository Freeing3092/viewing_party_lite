# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do
    @user1 = create(:user)
    @user2 = create(:user)
    visit '/'
  end

  describe 'as a visitor' do
    it 'I see the title of the application' do
      expect(page).to have_content('Viewing Party')
    end

    it 'I see a button to create a new user' do
      expect(page).to have_button('Create New User')
      click_button('Create New User')
      expect(current_path).to eq('/register')
    end

    it 'I do not see a list of existing users' do
      expect(page).to_not have_content(@user1.name)
      expect(page).to_not have_content(@user2.name)
    end

    it 'I see a link to the landing page' do
      expect(page).to have_link('Landing Page')
      click_link('Landing Page')
      expect(current_path).to eq('/')
    end

    it 'I see a link to login' do
      expect(page).to have_link('Log In')
      click_link 'Log In'
      expect(current_path).to eq('/login')
    end

    it 'if I try to visit my dashboard, I remain on the landing page And I see
    a message telling me that I must be logged in or registered to access my
    dashboard' do
      visit "/users/#{@user1.id}"

      expect(current_path).to eq('/')
      expect(page).to have_content('You must be logged in or registered to access your dashboard')
    end
  end

  describe 'as a logged in user' do  
    before :each do
      @user = User.create!(name: 'Watson', email: 'watson@sleuth.com', password: 'password')
      visit '/login'
      fill_in "email", with: "watson@sleuth.com"
      fill_in "password", with: "password"

      click_button 'Login'
      visit '/'
    end

    it "I no longer see a link to Log In or Create an Account But I see a link
    to Log Out. When I click the link to Log Out I'm taken to the landing page
    And I can see that the Log Out link has changed back to a Log In link" do
      expect(page).to have_no_link('Log In')
      expect(page).to have_no_button('Create New User')
      expect(page).to have_link('Log Out')

      click_link 'Log Out'
      
      expect(current_path).to eq('/')
      expect(page).to have_link('Log In')
      expect(page).to have_button('Create New User')
    end

    it 'I see the list of users as a list of email addresses' do
      within("#users") do
        expect(page).to have_content(@user1.email)
        expect(page).to have_content(@user2.email)
      end
    end
  end
end
