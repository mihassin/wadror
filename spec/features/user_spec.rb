require 'spec_helper'
include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right creds" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content "Welcome back!"
      expect(page).to have_content "Pekka"
    end

    it "is redirected back to signin form if wrong creds" do
      sign_in(username:"Pekka", password:"worpsd")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content "Username and password do not match!"
    end

    it "when signed up with good creds, is added to db" do
      visit signup_path
      fill_in('user_username', with:"Brian")
      fill_in('user_password', with:"Secret55")
      fill_in('user_password_confirmation', with:"Secret55")

      expect{
        click_button('Create User')
        }.to change{User.count}.by(1)
    end
  end
end
