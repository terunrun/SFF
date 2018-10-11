require 'rails_helper'

RSpec.feature "Perchase_product", type: :feature do
  # ユーザーは商品を購入する
  scenario "user perchase a product" do
    user = create(:user)
    seller = create(:user)
    product = create(:product, user: seller)

    sign_in user
    visit product_path(id: product.id)

    click_button "カートに入れる"
    expect(page).to have_content("ショッピングカート")

    click_link "購入画面へ"
    expect(page).to have_content("商品購入")

    # todo
    # expect{
    #   allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
    # }.to change(user.orders, :count).by(1)

    # ordering_mail = ActionMailer::Base.deliveries[0]
    # ordered_mail = ActionMailer::Base.deliveries[1]
    #
    # aggregate_failures do
    #   expect(ordering_mail.to).to eq [user.email]
    #   expect(ordered_mail.to).to eq [seller.email]
    # end

  end
end
