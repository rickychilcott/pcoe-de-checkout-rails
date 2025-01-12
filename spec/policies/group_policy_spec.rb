require "rails_helper"

RSpec.describe GroupPolicy, type: :policy do
  subject { described_class }

  permissions ".scope" do
    it "allows access to all admins for super_admin" do
      create(:group)

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          Group
        ).resolve
      ).to eq(Group.all)
    end

    it "allows access to all admins for non-super_admin" do
      create(:group)

      expect(
        described_class::Scope.new(
          build(:admin_user),
          Group
        ).resolve
      ).to eq(Group.all)
    end
  end

  permissions :index?, :show?, :create?, :update?, :destroy? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:group))
    end

    it "denies access for non-super_admin" do
      expect(subject).not_to permit(build(:admin_user), build(:group))
    end
  end
end
