FactoryBot.define do
  factory :inventory_item do
    survivor { create(:survivor) }
    item { create(:item) }
    quantity { 0 }

    trait :one do
      quantity { 1 }
    end

    trait :multiple do
      quantity { Faker::Number.within(range: 2..10)  }
    end
  end
end
