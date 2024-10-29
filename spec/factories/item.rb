FactoryBot.define do
  factory :item do
    name { Faker::Game.title }
    location
    group

    qr_code_identifier { SecureRandom.hex(4) }
  end
end
