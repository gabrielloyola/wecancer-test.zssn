FactoryBot.define do
  factory :item do
    name { Faker::Name.unique.name }
    value { Faker::Number.within(range: 1..4)  }
  end
end
