FactoryBot.define do
  factory :item do
    name { ['Água', 'Comida', 'Remédio', 'Munição'].sample }
    value { Faker::Number.within(range: 1..4)  }
  end
end
