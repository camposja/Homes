class HomesController < ApplicationController
  before_action :authenticate!, except: [:index, :show]

  # GET /homes
  def index
    params[:search] = params[:q] if params[:q].present?
    if params[:search]
      @homes = Home.where('zip ilike :pattern or description ilike :pattern or city ilike :pattern', pattern: "%#{params[:search]}%")
    else
      @homes = Home.order(:price)
    end

    @homes = @homes.page(params[:page]).per(5)
  end

  # GET /homes/1
  def show
    @home = Home.find(params[:id])
  end

  # GET /homes/new
  def new
    @home = Home.new
  end

  # GET /homes/1/edit
  def edit
    @home = Home.find(params[:id])
    unless @home.can_this_user_edit?(current_user)
      send_them_back_with_error
    end
  end

  # POST /homes
  def create
    @home = Home.new(home_params)
    @home.created_by = current_user

    if @home.save
      redirect_to @home, notice: 'Home was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /homes/1
  def update
    @home = Home.find(params[:id])

    unless @home.can_this_user_edit?(current_user)
      redirect_to homes_path, notice: "You are not allowed to Edit this home"
    end

    if @home.update(home_params)
      redirect_to @home, notice: 'Home was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /homes/1
  def destroy
    @home = Home.find(params[:id])

    unless @home.can_this_user_destroy?(current_user)
      send_them_back_with_error
    end

    @home.destroy
    redirect_to homes_url, notice: 'Home was successfully destroyed.'
  end

  def favorite
    # unless logged_in?
      # redirect_to login_path
    # end
    home = Home.find(params[:id])
    Favorite.create(home: home, user: current_user)
    Rails.logger.debug "FAVORITING"
  end

  def unfavorite
    home = Home.find(params[:id])
    favorite = Favorite.find_by(home: home, user: current_user)
    respond_to do |format|
      if favorite.destroy
        format.json { head :ok }
      else
        format.json { head :fail , message: login_url}
      end
    end
    Rails.logger.debug "UNFAVORITING"
  end

  private

  def send_them_back_with_error
    redirect_to homes_path, notice: "You are not allowed to Edit this home"
  end

  # Only allow a trusted parameter "white list" through.
  def home_params
    params.require(:home).permit(:address, :city, :state, :zip, :bedrooms, :baths, :square_feet, :price, :description, :image)
  end
end
