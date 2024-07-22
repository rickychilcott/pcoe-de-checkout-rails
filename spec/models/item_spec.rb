require "rails_helper"

RSpec.describe Item, type: :model do
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
end
