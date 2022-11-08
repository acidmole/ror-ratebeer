require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
    
    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")
  
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
        visit signup_path
        fill_in('user_username', with: 'Brian')
        fill_in('user_password', with: 'Secret55')
        fill_in('user_password_confirmation', with: 'Secret55')
    
        expect{
          click_button('Create User')
        }.to change{User.count}.by(1)
    end
  end


  describe "has ratings" do
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
      FactoryBot.create(:beer, name: "Kalex")
      FactoryBot.create(:beer, name: "Bisse")
      visit new_rating_path
      select('Kalex', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '45')
      click_button "Create Rating"
      visit new_rating_path
      select('Bisse', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '12')
      click_button "Create Rating"
    end
      
    it "shown on user page" do
      user2 = FactoryBot.create(:user, username: "Antti", password: "Foobar2", password_confirmation: "Foobar2")

      expect(page).to have_content 'Kalex'
      click_link "Sign out"

      sign_in(username: "Antti", password: "Foobar2")
      expect(page).not_to have_content 'Kalex'
    end

    it "deleted when clicked" do

      page.find_all('a[href="/ratings/1"]')[0].click
      expect(page).not_to have_content 'Kalex'
      expect(page).to have_content 'Bisse'
    end
  end
end