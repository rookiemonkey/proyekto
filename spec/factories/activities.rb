FactoryBot.define do
  factory :activity do
    description { Faker::Quote.famous_last_words }
    association :organization
  end
end
