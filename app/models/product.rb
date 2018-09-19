class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: "user"
  mount_uploader :image, PictureUploader

  validates :name, presence: true
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :stock, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { only_integer: true }

  def decrement_stock
    stock = self.stock - 1
    update_attribute(:stock, stock)
  end


end
