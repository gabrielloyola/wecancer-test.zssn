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

    trait :with_custom_item do
      transient do
        item_name { Faker::Name.unique.name }
        value { 1 }
      end

      item { Item.find_or_create_by!(name: item_name, value: value) }
    end
  end
end
