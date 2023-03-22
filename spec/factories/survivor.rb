require 'faker'

FactoryBot.define do
  factory :survivor do
    name { Faker::Name.name }
    age { Faker::Number.within(range: 0..120) }
    gender { ['Male', 'Female', 'Non-binary'].sample }
    infected { false }

    trait :with_location do
      last_lat { Faker::Number.decimal(l_digits: 3, r_digits: 5) }
      last_long { Faker::Number.decimal(l_digits: 3, r_digits: 5) }
    end

    trait :infected do
      infected { true }
    end

    trait :with_inventory_items do
      transient do
        item_quantity { 0 }
      end

      after(:create) do |survivor, evaluator|
        create_pair(:inventory_item, survivor: survivor, quantity: evaluator.item_quantity)
      end
    end
  end
end
