require 'faker'

FactoryBot.define do
  factory :survivor do
    name { Faker::Name.name }
    age { Faker::Number.within(range: 0..120) }
    gender { ['Male', 'Female', 'Non-binary'] }

    trait :with_location do
      last_lat { Faker::Number.decimal(l_digits: 3, r_digits: 5) }
      last_long { Faker::Number.decimal(l_digits: 3, r_digits: 5) }
    end
  end
end
