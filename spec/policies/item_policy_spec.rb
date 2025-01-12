require "rails_helper"

RSpec.describe ItemPolicy, type: :policy do
  let(:group) { create(:group) }

  subject { described_class }

  permissions ".scope" do
    it "allows access to all items for super_admin" do
      create(:item, group:)

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          Item
        ).resolve
      ).to eq(Item.all)
    end

    it "allows access to group items for non-super_admin" do
      user = create(:admin_user, groups: [group])
      item_1 = create(:item, group:)
      _item_2 = create(:item)

      expect(
        described_class::Scope.new(
          user, Item
        ).resolve
      ).to eq([item_1])
    end
  end

  permissions :index?, :show? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:item, group:))
    end

    it "allows access for non-super_admin" do
      expect(subject).to permit(build(:admin_user, groups: [group]), build(:item, group:))
    end
  end

  permissions :create?, :update?, :destroy? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:item, group:))
    end

    it "allows access in appropriate group for non-super_admin" do
      expect(subject).to permit(build(:admin_user, groups: [group]), build(:item, group:))
      expect(subject).not_to permit(build(:admin_user, groups: [group]), build(:item))
    end
  end
end
