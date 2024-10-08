# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ohio_id    :string           not null
#
require "rails_helper"

RSpec.describe Customer, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:customer)).to be_valid
  end
end
