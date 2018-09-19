class FavoritesController < ApplicationController
  def index
  end

  def create
    favorite = Favorite.new(user_id:current_user.id, product_id:params[:product_id])
    if favorite.save
      redirect_to product_path(params[:product_id]), notice: "お気に入りに登録しました"
    else
      render product_path(params[:product_id]), danger: "お気に入り登録に失敗しました"
    end
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, product_id: params[:id])
    favorite.destroy
    redirect_to product_path(params[:id]), notice: "お気に入りを解除しました"
  end
end
