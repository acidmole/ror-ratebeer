require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when given" do
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
      brewery1 = FactoryBot.create(:brewery, name: "Iisalamen panimo")
      brewery2 = FactoryBot.create(:brewery, name: "Kuopijon panimo")
      brewery3 = FactoryBot.create(:brewery, name: "Suomussalamen panimo")
      FactoryBot.create(:beer, name: "Kalex", style: "Lager", brewery: brewery1)
      FactoryBot.create(:beer, name: "Bisse", style: "Porter", brewery: brewery2)
      FactoryBot.create(:beer, name: "Stobe", style: "Pale ale", brewery: brewery2)
      FactoryBot.create(:beer, name: "Kolmonen", style: "Lager", brewery: brewery3)
      visit new_rating_path
      select('Kalex', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '18')
      click_button "Create Rating"
      visit new_rating_path
      select('Bisse', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '22')
      click_button "Create Rating"
      visit new_rating_path
      select('Stobe', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '20')
      click_button "Create Rating"
      visit new_rating_path
      select('Kolmonen', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '23')
      click_button "Create Rating"

    end
      
    it "is shown on user page" do
      user2 = FactoryBot.create(:user, username: "Antti", password: "Foobar2", password_confirmation: "Foobar2")

      expect(page).to have_content 'Kalex'
      click_link "Sign out"

      sign_in(username: "Antti", password: "Foobar2")
      expect(page).not_to have_content 'Kalex'
    end

    it "is deleted when clicked" do

      page.find_all('a[href="/ratings/1"]')[0].click
      expect(page).not_to have_content 'Kalex'
      expect(page).to have_content 'Bisse'
    end

    it "shows users favorite style and brewery" do
      expect(page).to have_content 'Favorite style: Porter'
      expect(page).to have_content 'Favorite brewery: Suomussalamen panimo'
    end
  end
end