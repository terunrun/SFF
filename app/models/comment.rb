class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :product_id, presence: true
  validates :user_id, presence: true
  validates :comment, presence: true, length: {maximum: 100}

end
