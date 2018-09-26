module ApplicationHelper
  def current_cart
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
      # 注文されたカートの場合は新しいカートを作成
      if !@cart.order_id.blank?
        @cart = Cart.create(user_id: current_user.id)
        session[:cart_id] = @cart.id
      end
    else
      @cart = Cart.create(user_id: current_user.id)
      session[:cart_id] = @cart.id
    end
  end
end
