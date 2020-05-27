class Admin::TouristSpotsController < ApplicationController
  before_action :authenticate_admin!
	before_action :set_tourist_spot, only: [:show, :edit, :update, :destroy]

  def index
    @tourist_spots = TouristSpot.all.page(params[:page]).per(20)
  end

  def show
  end

  def edit
    @genre_parent_array = ['---']
    # データベースから親カテゴリーのみを抽出し配列化
    Genre.where(ancestry: nil).each do |parent|
      @genre_parent_array << parent.name
    end
  end

  def update
		if @tourist_spot.update(tourist_spot_params)
			redirect_to admin_tourist_spot_path(@tourist_spot)
    else
			render 'edit'
		end
  end

	def destroy
		@tourist_spot.destroy
		redirect_to admin_tourist_spots_path
  end

  private

    def set_tourist_spot
      @tourist_spot = TouristSpot.find(params[:id])
    end

    def tourist_spot_params
			params.require(:tourist_spot).permit(
        :genre_id,
        :scene_id,
        :name,
        :postcode,
        :prefecture_code,
        :address_city,
        :address_street,
        :address_building,
        :introduction,
        :access,
        :phone_number,
        :business_hour,
        :is_parking,
        {images: []}
      )
    end
end
