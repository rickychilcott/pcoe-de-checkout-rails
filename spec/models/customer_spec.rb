# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  pid        :string
#  role       :string           default("student"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ohio_id    :string           not null
#
# Indexes
#
#  index_customers_on_ohio_id  (ohio_id) UNIQUE
#  index_customers_on_pid      (pid) UNIQUE
#
require "rails_helper"

RSpec.describe Customer, type: :model do
  it "has a valid factory" do
    expect(build(:customer)).to be_valid
  end

  it "requires PID, if student" do
    expect(build(:customer, role: :student, pid: nil)).not_to be_valid
  end

  it "doesn't require PID, if not student" do
    expect(build(:customer, role: :faculty_staff, pid: nil)).to be_valid
  end

  it "enforces PID format if provided and faculty/staff" do
    expect(build(:customer, role: :faculty_staff, pid: "P123")).not_to be_valid
  end
end
