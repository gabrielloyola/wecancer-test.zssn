FactoryBot.define do
  factory :infection_report do
    reporter_id { create(:survivor).id }
    infected_id { create(:survivor).id }
  end
end
