# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  ancestry           :string
#  name               :string           not null
#  qr_code_identifier :string
#  serial_number      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  group_id           :integer          not null
#  location_id        :integer
#  parent_item_id     :integer
#
# Indexes
#
#  index_items_on_ancestry        (ancestry)
#  index_items_on_group_id        (group_id)
#  index_items_on_location_id     (location_id)
#  index_items_on_parent_item_id  (parent_item_id)
#
# Foreign Keys
#
#  group_id        (group_id => groups.id)
#  location_id     (location_id => locations.id)
#  parent_item_id  (parent_item_id => items.id)
#
require "rails_helper"

RSpec.describe Item, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:item)).to be_valid
  end

  describe "parented" do
    it "doesn't require a parent" do
      item = FactoryBot.build(:item, parent: nil)
      expect(item).to be_valid
    end

    it "can have a parent" do
      item_parent = FactoryBot.create(:item)
      item = FactoryBot.build(:item)
      item.parent = item_parent

      expect(item).to be_valid
      expect(item.parent).to eq(item_parent)

      expect(item_parent).to be_valid
      expect(item_parent.parent).to eq(nil)
    end
  end

  describe ".importable_column_names" do
    it "returns the importable column names" do
      expect(described_class.importable_column_names).to eq(
        [
          "id",
          "name",
          "serial_number",
          "parent_item_id",
          "location_name",
          "qr_code_identifier",
          "group_name"
        ]
      )
    end
  end
end
