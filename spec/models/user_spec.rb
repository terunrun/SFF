require 'rails_helper'

RSpec.describe User, type: :model do

  describe User do

    # 名前、メールアドレス、パスワードがあるユーザーは有効であること
    it "is valid with name, email, password" do
      user = build(:user)
      expect(user).to be_valid
    end

    # 名前がないユーザーは無効であること
    it "is invalid without name" do
      user = build(:user, :without_name)
      expect(user).to be_invalid
    end

    # メールアドレスが重複しているユーザーは無効であること
    it 'is invalid with a duplicate email' do
      user = create(:user)
      other_user = build(:user, email: user.email)
      expect(other_user).to be_invalid
    end

    # メールアドレスが重複していないユーザーは無効であること
    it 'is valid with an another email' do
      user = create(:user)
      other_user = build(:user)
      expect(other_user).to be_valid
    end

    # traitの検証
    it "has 5 products" do
      user = create(:user, :with_products)
      expect(user.products.count).to eq 5
    end

  end

end
