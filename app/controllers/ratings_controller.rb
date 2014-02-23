class RatingsController < ApplicationController
  before_action :ensure_that_signed_in

  def index
    @ratings = Rating.all
    @top_beers = Beer.includes(:ratings).top 3
    @top_breweries = Brewery.includes(:ratings).top 3
    @top_styles = Style.includes(:ratings).top 3
    @most_active = User.includes(:ratings).most_active 3
    @recent = Rating.recent.includes(:user, :beer, beer: :brewery, beer: :style)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:"Sign in first!"
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end
