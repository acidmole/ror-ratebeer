class MembershipsController < ApplicationController
  def new
    memberships_of_current = current_user.memberships.map(&:beer_club)
    @beer_clubs = BeerClub.where.not(id: memberships_of_current)
    @membership = Membership.new
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id, :user_id)
    @membership.user = current_user

    if @membership.save
      redirect_to beer_clubs_path
    else
      @beer_clubs = BeerClub.all
      @membership = Membership.new
      render :new, status: :unprocessable_entity
    end
  end
end
