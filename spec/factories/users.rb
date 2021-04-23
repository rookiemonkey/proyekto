FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    password { '987654321' }
    full_name { Faker::Name.name }
    association :organization
  end
end
