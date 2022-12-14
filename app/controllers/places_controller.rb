class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      @weather = WeatherApi.weather_in(params[:city])
      render :index, status: 418
    end
  end

  def show
    @place = BeermappingApi.get_place(params[:id])
    redirect_to places_path, notice: "No place for id #{params[:id]}" if @place.empty?
  end
end
