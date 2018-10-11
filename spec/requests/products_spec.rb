require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create(:user) }

  # indexアクション
  describe "GET /products" do
    # 認証済みユーザーの場合
    context "as an authenticated user" do
      # 商品一覧が表示されること
      it "responds successfully" do
        sign_in user
        get products_path
        expect(response).to be_successful
      end
    end
    # 認証未済ユーザーの場合
    context "as a guest user" do
      # ログイン画面へリダイレクトすること
      it "redirects to sign in page" do
        get products_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # showアクション
  describe "GET /product" do
    # 認証済みユーザーの場合
    context "as an authenticated user" do
      before do
        @product = create(:product, user: user)
      end
      # 商品ページが表示されること
      it "responds successfully" do
        sign_in user
        get product_path(id: @product.id)
        expect(response).to be_successful
      end
    end
    # 認証未済ユーザーの場合
    context "as a guest user" do
      before do
        @product = create(:product)
      end
      # ログイン画面へリダイレクトすること
      it "redirects to sign in page" do
        get product_path(id: @product.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # createアクション
  describe "POST /products" do
    # 認証済みユーザーの場合
    context "as an authenticated user" do
      # 商品が登録されること
      it "adds a new product" do
        product_params = attributes_for(:product)
        sign_in user
        expect{
          post products_path, params: {product: product_params, user_id: user.id}
        }.to change(user.products, :count).by(1)
      end
    end
    # 認証未済ユーザーの場合
    context "as a guest user" do
      # ログイン画面へリダイレクトすること
      it "redirects to sign in page" do
        product_params = attributes_for(:product)
        expect{
          post products_path, params: {product: product_params, user_id: user.id}
        }.to_not change(user.products, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # updateアクション
  describe "PATCH /product" do
    before do
      @product = create(:product, user: user)
    end
    # 認証済みユーザーの場合
    context "as an authenticated user" do
      # 権限のあるユーザーの場合
      context "as an authorized user" do
        # 商品が更新されること
        it "updates a product" do
          product_params = attributes_for(:product, name: "Updated")
          sign_in user
          patch product_path(id: @product.id), params: {product: product_params}
          expect(@product.reload.name).to eq "Updated"
        end
      end
      # 権限のないユーザーの場合
      context "as an unauthorized user" do
        before do
          @other_user = create(:user)
        end
        # 商品が更新されないこと
        it "doesn't update a product" do
          product_params = attributes_for(:product, name: "Updated")
          sign_in @other_user
          patch product_path(id: @product.id), params: {product: product_params}
          expect(@product.reload.name).to_not eq "Updated"
        end
      end
    end
    # 認証未済ユーザーの場合
    context "as a guest user" do
      # ログイン画面へリダイレクトすること
      it "redirects to sign in page" do
        product_params = attributes_for(:product, name: "Updated")
        patch product_path(id: @product.id), params: {product: product_params}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
