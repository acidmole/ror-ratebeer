class MembershipsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]

  def new
    memberships_of_current = current_user.memberships.map(&:beer_club)
    @beer_clubs = BeerClub.where.not(id: memberships_of_current)
    @membership = Membership.new
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id, :user_id)
    @membership.user = current_user
    @beer_club = @membership.beer_club

    if @membership.save
      redirect_to beer_club_url(@beer_club), notice: "Welcome to the club, #{current_user.username}!"
    else
      @beer_clubs = BeerClub.all
      @membership = Membership.new
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @membership = Membership.find_by(beer_club_id: params[:beer_club_id], user_id: params[:user_id])
    @membership.destroy
    redirect_to user_url(current_user), notice: "Membership with #{@membership.beer_club.name} ended."
  end

end
