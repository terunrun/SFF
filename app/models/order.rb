class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true
  # validates :number, presence: true, numericality: { only_integer: true }

end
