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

  # 新しい画像が送られてきた場合
    if params[:spot][:images].present? && params[:spot][:images].any?(&:present?)
    # 既存画像は保持したまま、新しい画像を追加する
      @spot.images.attach(params[:spot][:images])
      params[:spot].delete(:images)  # ActiveStorage の上書きを防ぐ
    else
      # images が空なら params から削除（既存画像を消さない）
      params[:spot].delete(:images)
    end

    if @spot.update(spot_params)
      redirect_to @spot, notice: "更新しました"
    else
      render :edit
    end
  end

  def destroy
    @spot = Spot.find(params[:id])

    # 投稿者本人だけ削除できるようにする
    if @spot.user_id != current_user.id
      redirect_to spots_path, alert: "削除できません"
      return
    end

    @spot.destroy
    redirect_to spots_path, notice: "スポットを削除しました"
  end

  def delete_image
    @spot = Spot.find(params[:id])
    image = @spot.images.find(params[:image_id])

    image.purge

    redirect_to edit_spot_path(@spot), notice: "画像を削除しました"
  end

  private

  def spot_params
    params.require(:spot).permit(:title, :address, :description, images: [])
  end

end
