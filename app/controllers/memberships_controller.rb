class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_admin, only: [:destroy, :show, :index, :edit, :update]

  def index
    @memberships = Membership.all
  end

  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_club = BeerClub.all.reject{ |b| b.memberships.include? current_user }
  end

  # GET /memberships/1/edit
  def edit
  end

  def new_member
    @membership = Membership.new(membership_params)
    @membership.user = current_user
    @membership.confirmed = false
  end

  # POST /memberships
  # POST /memberships.json
  def create
    new_member

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_path(@membership.beer_club.id), notice: current_user.username+', welcome to the club, your application is pending!.' }
        format.json { render action: 'show', status: :created, location: @membership }
      else
        @beer_club = BeerClub.all.reject{ |b| b.memberships.include? current_user }
        format.html { render action: 'new' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    update_item(@membership, membership_params, "Membership")
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    destroy_item(@membership, memberships_url)
  end

  def toggle_confirmation
    membership = Membership.find(params[:id])
    unless membership.beer_club.member?(current_user)
      redirect_to :back, notice:'You are not a member of this Beer Club'
    else
      membership.confirmed = true
      membership.save
      redirect_to :back, notice:"Confirmed membership of #{membership.user.username}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
