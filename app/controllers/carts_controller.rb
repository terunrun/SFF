class CartsController < ApplicationController
  before_action :setup_cart_item!, except: :show

  def show
    current_cart
    @cart_items = @cart.cart_items
  end

  def add_item
    if @cart_item.blank?
      @cart_item = @cart.cart_items.build(product_id: params[:product_id])
    end
    product = Product.find(params[:product_id])
    @cart_item.quantity += params[:quantity].to_i
    if @cart_item.save
      if product.update_stock(product.stock - params[:quantity].to_i)
        redirect_to cart_path(@cart.id), notice: "カートに商品を追加しました"
      end
    end
  end

  def update_item
    cart_item = CartItem.find(params[:cart_item_id])
    current_stock = cart_item.product.stock + cart_item.quantity
    if params[:quantity].to_i < current_stock
      if cart_item.product.update_stock(current_stock - params[:quantity].to_i) &&
         cart_item.update_quantity(params[:quantity])
          redirect_to cart_path(@cart.id), notice: "商品数を変更しました"
      end
    else
      redirect_to cart_path(@cart.id), notice: "商品数を変更できません。残数を確認してください。"
    end
  end

  def delete_item
    cart_item = CartItem.find(params[:cart_item_id])
    cart_item.product.update_stock(cart_item.product.stock + cart_item.quantity)
    cart_item.delete
    redirect_to cart_path(@cart.id), notice: "商品をカートから削除しました"
  end

  private

  def setup_cart_item!
    current_cart
    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
  end

end
