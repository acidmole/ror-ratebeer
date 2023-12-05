class StylesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :set_style, only: %i[show edit update destroy]

  def index
    @styles = Style.all
  end

  def about
    render partial: 'about'
  end

  def show
    if turbo_frame_request?
      render partial: 'details', locals: { style: @style }
    end
    @style = set_style
    @beers = @style.beers
  end

  def new
    @style = Style.new
  end

  def create
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to style_url(@style), notice: "Style was successfully created." }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def style_params
    params.require(:style).permit(:name, :description)
  end

  def set_style
    @style = Style.find(params[:id])
  end
end
