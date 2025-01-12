require "rails_helper"

RSpec.describe AdminUserGroupPolicy, type: :policy do
  subject { described_class }

  permissions ".scope" do
    it "allows access to all admin_groups for super_admin" do
      group = create(:group)
      create(:admin_user, groups: [group])

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          AdminUserGroup
        ).resolve
      ).to eq(AdminUserGroup.all)
    end

    it "allows access to all admin_groups for non-super_admin" do
      group = create(:group)
      create(:admin_user, groups: [group])

      expect(
        described_class::Scope.new(
          build(:admin_user),
          AdminUserGroup
        ).resolve
      ).to eq(AdminUserGroup.all)
    end
  end

  permissions :index?, :show? do
    it "allows access for super_admin" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      admin_user_group = admin_user.admin_groups.first

      expect(subject).to permit(build(:admin_user, :super_admin), admin_user_group)
    end

    it "allows access for non-super_admin" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      admin_user_group = admin_user.admin_groups.first

      expect(subject).to permit(build(:admin_user), admin_user_group)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "allows access for super_admin" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      admin_user_group = admin_user.admin_groups.first

      expect(subject).to permit(build(:admin_user, :super_admin), admin_user_group)
    end

    it "denies access for non-super_admin" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      admin_user_group = admin_user.admin_groups.first

      expect(subject).not_to permit(build(:admin_user), admin_user_group)
    end
  end
end
