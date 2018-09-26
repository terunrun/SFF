class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :cart_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true }

  def update_quantity(quantity)
    update_attribute(:quantity, quantity)
  end

end
