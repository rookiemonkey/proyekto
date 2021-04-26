FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    plan { 'enterprise' }
    subdomain { 'example-subdomain' }
  end
end
