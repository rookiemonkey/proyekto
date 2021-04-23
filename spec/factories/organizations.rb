FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    subdomain { 'example-subdomain' }
  end
end
