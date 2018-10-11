FactoryBot.define do
  factory :product do
    # sequenceでユニークな値設定が可能
    sequence(:name) { |n| "product_#{n}" }
    # associationで関連付けが可能
    association :user
    # association :category
    category_id {1}
    sequence(:price) { |n| n * 100 }
    sequence(:stock) { |n| n }
    description { "MyString" }

    # 継承によって任意の属性値のみが異なるデータの定義が可能
    factory :with_images do
      images {File.new("{Rails.root}/spec/files/attachment.jpg")}
    end

    # traitで任意の属性値を持つデータの定義が可能
    trait :with_images do
      images {File.new("{Rails.root}/spec/files/attachment.jpg")}
    end
  end
end
