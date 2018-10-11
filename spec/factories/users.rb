FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}"}
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }

    # 名前がないユーザー
    trait :without_name do
      name nil
    end

    # コールバックを使用してユーザー作成と同時に商品を作成
    trait :with_products do
      after(:create) { |user| create_list(:product, 5, user: user)}
    end
  end
end
