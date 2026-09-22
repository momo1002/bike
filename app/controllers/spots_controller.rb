class SpotsController < ApplicationController
  def index
    @spots = Spot.includes(:user, images_attachments: :blob).order(created_at: :desc)
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)
    @spot.user = current_user

    if @spot.save
      redirect_to spots_path, notice: "スポットを投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    @spot = Spot.find(params[:id])

    if @spot.update(spot_params)
      redirect_to spot_path(@spot), notice: "スポットを更新しました"
   else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def spot_params
    params.require(:spot).permit(
      :title,
      :description,
      :address,
      images: []
    )
  end
end
