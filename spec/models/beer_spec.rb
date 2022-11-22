require 'rails_helper'

RSpec.describe Beer, type: :model do
  
  describe "it is" do
    let(:test_brewery) { Brewery.create name: "test", year: 2000, id:1 }
    let(:test_style1) { Style.create name: "Kahvinen", description: "n/a"}
    let(:test_style2) { Style.create name: "Blanc", description: "n/a"}
    
    it "saved to database with proper information provided" do
      beer = Beer.create name: "Kohvik", style: test_style1, brewery: test_brewery 

      expect(beer.valid?).to be(true)
      expect(Beer.count).to eq(1)
    end

    it "not saved to database if it has no name" do
      beer = Beer.create style: test_style2, brewery: test_brewery 

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
