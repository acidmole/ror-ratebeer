class RatingsController < ApplicationController

  PAGE_SIZE = 5

  def index

    @order =
      if params[:order] == "true"
        true
      else
        false
      end

    @page = params[:page]&.to_i || 1
    @last_page = (Rating.count / PAGE_SIZE).ceil
    offset = (@page - 1) * PAGE_SIZE

    @ratings = Rating.all
    @recents = Rating.recent
    @top_breweries = Brewery.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
    @active_users = User.most_active 3
    if @order
      @listed_ratings = Rating.order(:created_at).limit(PAGE_SIZE).offset(offset)
    else
      @listed_ratings = Rating.order("#{:created_at} DESC").limit(PAGE_SIZE).offset(offset)
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def show

    @rating = set_rating
    if turbo_frame_request?
      render partial: "beer_details", locals: { rating: @rating }
    end


  end

  def set_rating
    rating = Rating.find(params[:id])
  end
  def create
    @rating = Rating.new

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    destroy_ids = request.body.string.split(',')
    # Loop through multiple rating IDs and delete them if they exist and belong to the current user
    destroy_ids.each do |id|
      rating = Rating.find_by(id: id)
      rating.destroy if rating && current_user == rating.user
      # Rescue in case one of the rating IDs is invalid so we can continue deleting the rest
    rescue StandardError => e
      puts "Rating record has an error: #{e.message}"
    end
    @user = current_user
    respond_to do |format|
      format.html { render partial: '/users/ratings', status: :ok, user: @user }
    end
  end
  def rating_params
    params.require(:rating).permit(:score, :beer_id)
  end


end
