FactoryBot.define do
  factory :project do
    name { Faker::Movie.title }
    association :organization
  end
end
