module ApplicationHelper
  def current_cart
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
    else
      @cart = Cart.create(user_id: current_user.id)
      session[:cart_id] = @cart.id
    end
  end
end
