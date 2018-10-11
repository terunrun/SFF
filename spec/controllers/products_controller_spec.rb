require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { create(:user) }

  # indexアクション
  describe "#index" do
    # 認証済みユーザーの場合
    context "as an authenticate user" do
      # レスポンスが正常に返ること
      it "response successfully" do
        # deviseの」ヘルパーを使用してログイン状態を作る
        sign_in user
        # indexアクションへgetリクエスト
        get :index
        expect(response).to be_successful
      end
      # レスポンスのステータスコードが200であること
      it "returns a 200 response" do
        sign_in user
        get :index
        expect(response).to have_http_status(200)
      end
    end
    # 認証未済ユーザーの場合
    context "as a guest user" do
      # レスポンスのステータスコードが302であること
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status(302)
      end
      # ログイン画面へリダイレクトすること
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # showアクション
  describe "#show" do
    # 各エクスペクテーションで使用するためbeforeで定義
    before do
      @product= create(:product)
    end
    # 認証済みユーザーの場合
    context "as an authenticate user" do
      # レスポンスが正常に返ること
      it "response successfully" do
        sign_in user
        get :show, params: {id: @product.id}
        expect(response).to be_successful
      end
      # レスポンスのステータスコードが200であること
      it "returns a 200 response" do
        sign_in user
        get :show, params: {id: @product.id}
        expect(response).to have_http_status(200)
      end
    end
    # 認証未済ユーザーの場合
    context "as a guest user" do
      # レスポンスのステータスコードが302であること
      it "returns a 302 response" do
        get :show, params: {id: @product.id}
        expect(response).to have_http_status(302)
      end
      # ログイン画面へリダイレクトすること
      it "redirects to sign in page" do
        get :show, params: {id: @product.id}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # createアクション
  describe "#create" do
    # 認証済みユーザーの場合
    context "as an authenticate user" do
      # 有効なパラメータの場合
      context "with valid parameters" do
        # ユーザーに紐づく商品数が1つ増えること
        it "adds a product" do
          product_params = attributes_for(:product)
          sign_in user
          expect{
            post :create, params: { product: product_params, user_id: user.id }
          }.to change(user.products, :count).by(1)
        end
      end
      # 無効なパラメータの場合
      context "with invalid parameters" do
        # ユーザーに紐づく商品数が変化しないこと
        it "doesn't add a product" do
          product_params = attributes_for(:product, name: nil)
          sign_in user
          expect{
            post :create, params: { product: product_params, user_id: user.id }
          }.to_not change(user.products, :count)
        end
      end
    end
    context "as a guest user" do
      it "returns a 302 response" do
        product_params = attributes_for(:product)
        post :create, params: { product: product_params }
        expect(response).to have_http_status(302)
      end
      it "redirects to sign in page" do
        product_params = attributes_for(:product)
        post :create, params: { product: product_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # updateアクション
  describe "#update" do
    # 認証済みかつ権限があるユーザーの場合
    context "as an authenticate user" do
      # 有効なパラメータの場合
      context "with valid parameters" do
        before do
          @product = create(:product, user: user, name: "Product")
        end
        # 更新が成功すること
        it "updates product" do
          product_params = attributes_for(:product, name: "updated")
          sign_in user
          post :update, params: { product: product_params, id: @product.id }
          expect(@product.reload.name).to eq "updated"
        end
      end
      # 無効なパラメータの場合
      context "with invalid parameters" do
        before do
          @product = create(:product, user: user, name: "Product")
        end
        # 更新が成功しないこと
        it "doesn't update product" do
          product_params = attributes_for(:product, name: nil)
          sign_in user
          post :update, params: { product: product_params, id: @product.id }
          expect(@product.reload.name).to eq "Product"
        end
      end
      # 更新対象の商品を登録したユーザーでない場合
      context "as an unauthorized user" do
        before do
          @product = create(:product, user: user, name: "Product")
        end
        # 更新が成功しないこと
        it "doesn't update product" do
          other_user = create(:user, email: "other@example.com")
          product_params = attributes_for(:product, name: "updated")
          sign_in other_user
          post :update, params: { product:product_params, id: @product.id}
          expect(@product.reload.name).to_not eq "updated"
        end
      end
    end
    context "as a guest user" do
      # omitted
    end
  end

  # newアクション
  # editアクション
  # sortアクション
  # image_detailアクション
  # indexの検索


end
