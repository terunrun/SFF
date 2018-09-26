module ApplicationHelper
  def current_cart
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
      # 注文済カートの場合は新しいカートを作成
      if !@cart.order_id.blank?
        @cart = Cart.create(user_id: current_user.id)
        session[:cart_id] = @cart.id
      end
    else
      # where句で検索する場合、結果が1件でも複数件として扱われるため、firstで強制的に1件にする
      @cart = Cart.where(user_id: current_user.id).where(order_id: nil).first
      if @cart.blank?
        @cart = Cart.create(user_id: current_user.id)
        session[:cart_id] = @cart.id
      end
    end
  end
end
