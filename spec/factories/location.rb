FactoryBot.define do
  factory :location do
    name { Faker::Locations::Australia.location }
  end
end
