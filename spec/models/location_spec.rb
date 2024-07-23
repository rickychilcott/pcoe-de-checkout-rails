# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Location, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:location)).to be_valid
  end
end
