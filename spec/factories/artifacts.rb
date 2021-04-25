FactoryBot.define do
  factory :artifact do
    name { Faker::Construction.material }
    description { Faker::Quote.famous_last_words }
    association :project
  end
end
