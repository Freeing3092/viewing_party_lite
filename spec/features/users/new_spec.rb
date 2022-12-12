# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'New User' do
  before :each do
    User.create!(name: 'Watson', email: 'watson@sleuth.com', password: 'password')
    visit '/register'
  end
  describe 'as a user' do
    it "I see a form to register a new user. Once the user registers they
    should be taken to a dashboard page '/users/:id', where :id is the id
    for the user that was just created." do
      fill_in 'name', with: 'Sherlock'
      fill_in 'email', with: 'sherlockh@sleuth.com'
      fill_in 'password', with: 'password123'
      fill_in 'password_confirmation', with: 'password123'
      click_button 'Register User'
      
      user = User.last
      expect(current_path).to eq("/users/#{user.id}")
    end
    
    it 'if an email has already been registered the user is redirected to
    the form to register a new user where they see an error indicating
    the email already exists.' do
      fill_in 'name', with: 'Watson'
      fill_in 'email', with: 'watson@sleuth.com'
      fill_in 'password', with: 'password123'
      fill_in 'password_confirmation', with: 'password123'
      click_button 'Register User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('Email has already been taken')
    end
    
    it "if the password and password_confirmation don't match, the user is redirected to
    the form to register a new user where they see an error indicating
    the passwords don't match." do
      fill_in 'name', with: 'Ulrich'
      fill_in 'email', with: 'ulrich@time.com'
      fill_in 'password', with: 'password123'
      fill_in 'password_confirmation', with: 'password124'
      click_button 'Register User'

      expect(current_path).to eq('/register')
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
