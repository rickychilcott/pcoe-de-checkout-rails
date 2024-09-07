FactoryBot.define do
  factory :checkout do
    item
    customer

    checked_out_at { Faker::Date.backward(days: 10) }
    checked_out_by { create(:admin_user) }

    expected_return_on { Faker::Date.forward(days: 23) }
  end
end
