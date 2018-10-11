require 'rails_helper'

RSpec.describe Product, type: :model do

  describe Product do

    # 正常系
    it "is valid with name, user, category, price, stock" do
      product = build(:product)
      expect(product).to be_valid
    end

    # 異常系：名前なし
    it "is invalid without name" do
      product = build(:product, name: nil)
      expect(product).to be_invalid
    end

    # 正常系：名前が別ユーザーで重複
    it "allows two users to share same name" do
      user = create(:user)
      other_user = create(:user)
      product = create(:product, user: user, name: "Test")
      other_product = build(:product, user: other_user, name: "Test")
      expect(other_product).to be_valid
    end

    # 異常系：名前が同一ユーザーで重複
    it "is not allow duplicate names per user" do
      user = create(:user)
      product = create(:product, user: user, name: "Test")
      other_product = build(:product, user: user, name: "Test")
      expect(other_product).to be_invalid
    end

    # 異常系：ユーザーなし
    it "is invalid without user_id" do
      product = build(:product, user: nil)
      expect(product).to be_invalid
    end

    # 異常系：カテゴリなし
    it "is invalid without category_id" do
      product = build(:product, category: nil)
      expect(product).to be_invalid
    end

    # 異常系：値段なし
    it "is invalid without price" do
      product = build(:product, price: nil)
      expect(product).to be_invalid
    end

    # 異常系：値段が数値でない
    it "is invalid when price is not a number" do
      product = build(:product, price: "abc")
      expect(product).to be_invalid
    end

    # 異常系：在庫なし
    it "is invalid without stock" do
      product = build(:product, stock: nil)
      expect(product).to be_invalid
    end

    # 異常系：在庫が数値でない
    it "is invalid when stock is not a number" do
      product = build(:product, stock: "abc")
      expect(product).to be_invalid
    end

    # 正常系：update_stockメソッド
    it 'changes its stock to argument' do
      product = create(:product, stock: 5)
      expect{product.update_stock(8)}.to change{product.stock}.from(5).to(8)
    end

  end

end
