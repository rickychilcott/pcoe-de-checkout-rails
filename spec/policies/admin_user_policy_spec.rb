require "rails_helper"

RSpec.describe AdminUserPolicy, type: :policy do
  subject { described_class }

  permissions ".scope" do
    it "allows access to all admins for super_admin" do
      create(:admin_user)

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          AdminUser
        ).resolve
      ).to eq(AdminUser.all)
    end

    it "allows access to all admins for non-super_admin" do
      create(:admin_user)

      expect(
        described_class::Scope.new(
          build(:admin_user), AdminUser
        ).resolve
      ).to eq(AdminUser.all)
    end
  end

  permissions :index?, :show? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:admin_user))
    end

    it "allows access for non-super_admin" do
      expect(subject).to permit(build(:admin_user), build(:admin_user))
    end
  end

  permissions :create?, :update?, :destroy? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:admin_user))
    end

    it "denies access for non-super_admin" do
      expect(subject).not_to permit(build(:admin_user), build(:admin_user))
    end
  end
end
