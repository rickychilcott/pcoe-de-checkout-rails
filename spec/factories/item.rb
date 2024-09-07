FactoryBot.define do
  factory :item do
    name { Faker::Game.title }
    location
    group
  end
end
