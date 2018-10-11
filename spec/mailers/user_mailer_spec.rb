require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  # 発注メール
  describe "ordering mail" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.ordering(user) }

    # 注文者に送信されること
    it "sends mail to ordering user" do
      expect(mail.to).to eq [user.email]
    end

    # 送信元が正しいこと
    it "sends from correct email address" do
      expect(mail.from).to eq ["norply@example.com"]
    end

    # タイトルが正しいこと
    it "sends with correct subject" do
      expect(mail.subject).to eq "商品注文完了のお知らせ"
    end

    # 本文に注文者名が存在すること
    it "has user name in mail body" do
      expect(mail.body).to match user.name
    end
  end

  # 受注メール
  describe "ordered mail" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.ordered(user) }

    # 販売者に送信されること
    it "sends mail to ordered user" do
      expect(mail.to).to eq [user.email]
    end

    # 送信元が正しいこと
    it "sends from correct email address" do
      expect(mail.from).to eq ["norply@example.com"]
    end

    # タイトルが正しいこと
    it "sends with correct subject" do
      expect(mail.subject).to eq "商品受注のお知らせ"
    end

    # 本文に販売者名が存在すること
    it "has user name in mail body" do
      expect(mail.body).to match user.name
    end
  end
end
