require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      OpenStruct.new( {"observation_time":"01:04 PM","temperature":-1,"weather_code":113,"weather_icons":["https:\/\/cdn.worldweatheronline.com\/images\/wsymbols01_png_64\/wsymbol_0001_sunny.png"],"weather_descriptions":["Sunny"],"wind_speed":4,"wind_degree":10,"wind_dir":"N","pressure":1028,"precip":0,"humidity":66,"cloudcover":0,"feelslike":-6,"uv_index":2,"visibility":16,"is_day":"yes"})
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several places are found by the API, it lists all of them on the page" do

    allow(BeermappingApi).to receive(:places_in).with("Olari").and_return(
      [ Place.new( name: "Aloha & Bar Ohana", id: 1 ), 
        Place.new( name: "Olarin kulma", id: 2),
        Place.new( name: "Olarius", id: 3),
        Place.new( name: "Davisto", id: 4) ]
    )

    allow(WeatherApi).to receive(:weather_in).with("Olari").and_return(
      OpenStruct.new( {"observation_time":"01:04 PM","temperature":-1,"weather_code":113,"weather_icons":["https:\/\/cdn.worldweatheronline.com\/images\/wsymbols01_png_64\/wsymbol_0001_sunny.png"],"weather_descriptions":["Sunny"],"wind_speed":4,"wind_degree":10,"wind_dir":"N","pressure":1028,"precip":0,"humidity":66,"cloudcover":0,"feelslike":-6,"uv_index":2,"visibility":16,"is_day":"yes"})
    )

    visit places_path
    fill_in('city', with: 'Olari')
    click_button "Search"

    expect(page).to have_content "Ohana"
    expect(page).to have_content "kulma"
    expect(page).to have_content "Olarius"
    expect(page).to have_content "Davisto"
  end

  it "if search has no matches, it will return to search page with a notice" do
    allow(BeermappingApi).to receive(:places_in).with("Peräseinäjoki").and_return([])
    
    visit places_path
    fill_in('city', with: 'Peräseinäjoki')
    click_button "Search"
    expect(current_path).to eq(places_path)
    expect(page).to have_content("No locations in Peräseinäjoki")
  end
      
end