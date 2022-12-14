require 'rails_helper'

RSpec.describe User, type: :model do

  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"
  
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved without a password not meeting criteria" do
    user = User.create username: "Antti", password: "joku", password_confirmation: "joku"
    user2 = User.create username: "Jaakko", password: "Abc", password_confirmation: "Abc"

    expect(user.valid?).to be(false)
    expect(user2.valid?).to be(false)
    expect(User.count).to eq(0)
  end  

  describe "with a proper password" do
    let(:user){ User.create username: "Pekka", password: "Secret1", password_confirmation: "Secret1" }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_style) { Style.new name: "teststyle", description: "test"}
    let(:test_beer) { Beer.create name: "testbeer", style: test_style, brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score: 10, beer: test_beer
      rating2 = Rating.new score: 20, beer: test_beer

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      beer1 = FactoryBot.create(:beer)
      beer2 = FactoryBot.create(:beer)
      beer3 = FactoryBot.create(:beer)
      rating1 = FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 25, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 9, beer: beer3, user: user)
    
      expect(user.favorite_beer).to eq(beer2)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with highest average rating if several rated" do
      style1 = FactoryBot.create(:style, name: "Porter")
      style2 = FactoryBot.create(:style) #lager
      beer1 = FactoryBot.create(:beer, style: style1)
      beer2 = FactoryBot.create(:beer, style: style2)
      beer3 = FactoryBot.create(:beer, style: style2)
      rating1 = FactoryBot.create(:rating, score: 24, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 25, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 17, beer: beer3, user: user)
      expect(user.favorite_style).to eq(beer1.style.name)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end
    it "is the one with highest average rating if several rated" do
      brewery1 = FactoryBot.create(:brewery, name: "Heineken")
      brewery2 = FactoryBot.create(:brewery, name: "Carlsberg")
      beer1 = FactoryBot.create(:beer, brewery: brewery1)
      beer2 = FactoryBot.create(:beer, brewery: brewery2)
      beer3 = FactoryBot.create(:beer, brewery: brewery2)
      rating1 = FactoryBot.create(:rating, score: 32, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 40, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 15, beer: beer3, user: user)
      expect(user.favorite_brewery).to eq(brewery1.name)
    end
  end

end
