class Order < ApplicationRecord
  belongs_to :user
  has_many :carts, dependent: :destroy

  validates :user_id, presence: true
  validates :total_price, presence: true

end
