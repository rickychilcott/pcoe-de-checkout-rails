require "rails_helper"

RSpec.describe ActivityPolicy, type: :policy do
  let(:group) { create(:group) }

  subject { described_class }

  permissions ".scope" do
    it "allows access to all items for super_admin" do
      create(:item, group:)

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          Activity
        ).resolve
      ).to eq(Activity.all)
    end

    it "allows access to group items for non-super_admin" do
      expect(
        described_class::Scope.new(
          build(:admin_user, groups: [group]),
          Activity
        ).resolve
      ).to eq(Activity.all)
    end
  end

  permissions :index?, :show? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:activity))
    end

    it "allows access for non-super_admin" do
      expect(subject).to permit(build(:admin_user, groups: [group]), build(:activity))
    end
  end

  permissions :create?, :update?, :destroy? do
    it "allows access for super_admin" do
      expect(subject).not_to permit(build(:admin_user, :super_admin), build(:activity))
    end

    it "allows access in appropriate group for non-super_admin" do
      expect(subject).not_to permit(build(:admin_user, groups: [group]), build(:activity))
    end
  end
end
