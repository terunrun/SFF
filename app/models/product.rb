class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: "user"
  has_many :cart_items, dependent: :destroy
  # 複数画像のアップロードに対応する mount_uploader⇒mount_uploaders
  mount_uploaders :images, PictureUploader

  # uniquenessにuser_idのスコープをつける（同一userでの一意制限）
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :stock, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { only_integer: true }

  def update_stock(stock)
    update_attribute(:stock, stock)
  end

end
