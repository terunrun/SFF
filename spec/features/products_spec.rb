require 'rails_helper'

RSpec.feature "Products", type: :feature do
  let(:user) { create(:user) }

  # ユーザーは新しい商品を登録する
  scenario "user creates a new product" do
    # ルート画面からログインリンクをクリックしてログインする
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    # ようこその文言が表示されること
    expect(page).to have_content("ようこそ！#{user.name}様")

    expect{
      # 商品登録画面へ移動し、商品登録する
      click_link "商品登録"
      # デバッグ用　テストで実際に描画された画面を出力
      # save_and_open_page
      expect(page).to  have_content("商品登録")
      fill_in "商品名", with: "new product"
      # 第一引数で選択するオプション、fromでselect_boxを指定
      select '映画', from: 'product_category_id'
      fill_in "価格", with: 100
      fill_in "個数", with: 99
      # attach_fileでファイルアップロードをテスト
      # matchで複数マッチした要素のどれにするかを指定
      attach_file "Images", "spec/files/attachment.jpg", match: :first
      click_button "登録"

      # 商品一覧へ移動し、登録された商品情報が表示されること
      aggregate_failures do
        expect(current_path).to eq products_path
        expect(page).to have_content("商品名：new product")
        expect(page).to have_content("販売者：#{user.name}")
        expect(page).to have_content("価格：100")
        expect(page).to have_content("残数：99")
      end
    # userのproductが1つ増えること
    }.to change(user.products, :count).by(1)
  end

  scenario "user updates product information", focus: true do
    product = create(
      :product, user: user, name: "商品情報変更テスト", price: 200, stock: 3, description: "テスト"
    )
    sign_in user
    visit product_path(id: product.id)

    expect(page).to have_content("商品詳細")
    click_link "商品情報変更"

    expect(page).to have_content("商品情報変更")
    # 商品名フィールドに現在の商品名が入っているか
    expect(find('#product_name').value).to eq "商品情報変更テスト"

    fill_in "商品名", with: "商品情報変更テスト後"
    click_button "変更"

    aggregate_failures do
      expect(page).to have_content("商品名：商品情報変更テスト後")
      expect(page).to have_content("商品説明：テスト")
      expect(page).to have_content("価格：200")
      expect(page).to have_content("在庫：3")

      # expect(product.reload.name).to eq "商品情報変更テスト後"
      # expect(product.reload.price).to eq 200
      # expect(product.reload.stock).to eq 3
      # expect(product.reload.description).to eq "テスト"
    end

  end

  scenario "user adds comment to a product" do
    product = create(:product, name: "コメント追加テスト用商品")
    sign_in user
    visit products_path
    click_link "コメント追加テスト用商品"

    expect(page).to have_content("商品詳細")
    expect(page).to have_content("コメント追加テスト用商品")

    expect{
      # labelの指定の仕方に注意
      fill_in "comment_comment", with: "テストコメント"
      click_button "コメント投稿"
    }.to change(product.comments, :count).by(1)
  end


end
