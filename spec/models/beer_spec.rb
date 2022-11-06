require 'rails_helper'

RSpec.describe Beer, type: :model do
  
  describe "it is" do
    let(:test_brewery) { Brewery.create name: "test", year: 2000, id:1 }
    
    it "saved to database with proper information provided" do
      beer = Beer.create name: "Kohvik", style: "kahvinen", brewery: test_brewery 

      expect(beer.valid?).to be(true)
      expect(Beer.count).to eq(1)
    end

    it "not saved to database if it has no name" do
      beer = Beer.create style: "blanc", brewery: test_brewery 

      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end

    it "not saved to database if it has no style" do
      beer = Beer.create name: "birra", brewery: test_brewery 

      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end
  end
end
