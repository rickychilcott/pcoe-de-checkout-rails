FactoryBot.define do
  factory :admin_user do
    name { "MyString" }
    email { Faker::Internet.email }
  end
end
