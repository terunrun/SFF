class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.new
    current_cart
    @cart_items = @cart.cart_items
    @cart_items.each do |cart_item|
      @order.total_price += cart_item.product.price * cart_item.quantity
    end
  end

  def create
    current_cart
    @cart_items = @cart.cart_items
    @order = Order.new(user_id: current_user.id)
    @cart_items.each do |cart_item|
      @order.total_price += cart_item.product.price * cart_item.quantity
    end
    if @order.save && @cart.update_attribute(:order_id, @order.id)
      Payjp.api_key = "sk_test_c2addc6ea3e0046d801e3aef"
        charge = Payjp::Charge.create(
          :amount => @order.total_price,
          :card => params["payjp-token"],
          :currency => "jpy",
        )
      UserMailer.ordering(current_user).deliver_now
      @cart_items.each do |cart_item|
        UserMailer.ordered(cart_item.product.user).deliver_now
      end
      redirect_to products_path, notice: 'ご注文ありがとうございました。'
    else
      render :new, danger: '商品の注文に失敗しました。'
    end
  end

    # private
    #
    # def order_params
    #   params.require(:order).permit(:price)
    # end

end
