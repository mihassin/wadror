class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.by_place_id(params[:id], session[:city])
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:city] = params[:city]
    if @places.empty?
      redirect_to places_path, :notice => "No places in #{params[:city]}"
    else
      render :index
    end
  end
end

