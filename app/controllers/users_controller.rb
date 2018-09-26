class UsersController < ApplicationController
  before_action :authenticate_user!

  # ページネーション用
  PER = 50

  def index
    @users = User.all.order(name: "ASC").page(params[:page]).per(PER)
  end

  def show
    @user = User.find(params[:id])
    @products = @user.products.all.order(name: "ASC").page(params[:page]).per(PER)
    @favorites = @user.favorite_products
    @orders = @user.orders
  end

end
