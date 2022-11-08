require 'rails_helper'
include Helpers

describe "Beer" do
  before :each do
    @user1 = FactoryBot.create :user
    @brewery1 = FactoryBot.create :brewery
    sign_in(username: "Pekka", password: "Foobar1")
  end

  describe "when created" do
    before :each do
        visit new_beer_path
    end
    it "is accepted if it has a name" do
        fill_in('beer[name]', with: 'Kalex')
        select('Porter', from: 'beer[style]')
        select('anonymous', from: 'beer[brewery_id]')
        expect{
            click_button('Create Beer')
          }.to change{Beer.count}.by(1)
    end
    it "is not accepted if it has no name" do
        click_button('Create Beer')
            
        expect(page).to have_content '1 error prohibited this beer from being saved:'
    end
  end
end