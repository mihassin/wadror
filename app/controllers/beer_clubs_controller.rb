class BeerClubsController < ApplicationController
  before_action :set_beer_club, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_member, only: [:edit, :delete]

  # GET /beer_clubs
  # GET /beer_clubs.json
  def index
    @beer_clubs = BeerClub.all
  end

  # GET /beer_clubs/1
  # GET /beer_clubs/1.json
  def show
    @membership = Membership.new
    @membership.beer_club = @beer_club
    @confirmed = Membership.where(confirmed:true, beer_club_id:@beer_club.id)
    @unconfirmed = Membership.where(confirmed:[nil,false], beer_club_id:@beer_club.id)
  end

  # GET /beer_clubs/new
  def new
    @beer_club = BeerClub.new
  end

  # GET /beer_clubs/1/edit
  def edit
  end

  # POST /beer_clubs
  # POST /beer_clubs.json
  def create
    @beer_club = BeerClub.new(beer_club_params)

    respond_to do |format|
      if @beer_club.save
        @beer_club.memberships.create user_id:current_user.id, confirmed:true
        format.html { redirect_to @beer_club, notice: 'Beer club was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beer_club }
      else
        format.html { render action: 'new' }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_clubs/1
  # PATCH/PUT /beer_clubs/1.json
  def update
    update_item(@beer_club, beer_club_params, "Beer Club")
  end

  # DELETE /beer_clubs/1
  # DELETE /beer_clubs/1.json
  def destroy
    destroy_item(@beer_club, beer_clubs_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer_club
      @beer_club = BeerClub.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_club_params
      params.require(:beer_club).permit(:name, :founded, :city)
    end

    def ensure_that_member
          redirect_to :back, notice:'only members are allowed' unless @beer_club.member?(current_user)
    end
end
