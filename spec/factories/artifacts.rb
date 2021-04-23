FactoryBot.define do
  factory :artifact do
    name { Faker::Construction.material }
    association :project
  end
end
