class UserMailer < ApplicationMailer
  default from: 'norply@example.com'

  def ordering(user)
    @user = user
    mail(to: @user.email, subject: "商品注文完了のお知らせ")
  end

  def ordered(user)
    @user = user
    mail(to: @user.email, subject: "商品受注のお知らせ")
  end

end
