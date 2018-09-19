class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.new
    @product = Product.find(params[:product_id])
  end

  def create
    @order = Order.new
    @order.product_id = params[:product_id]
    @order.user_id = params[:user_id]
    @product = Product.find(params[:product_id])
    if @order.save
      Payjp.api_key = "sk_test_c2addc6ea3e0046d801e3aef"
          charge = Payjp::Charge.create(
          :amount => @product.price,
          :card => params["payjp-token"],
          :currency => "jpy",
        )
      @product.decrement_stock
      UserMailer.ordering(current_user).deliver_now
      UserMailer.ordered(Product.find(params[:product_id]).user).deliver_now
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
