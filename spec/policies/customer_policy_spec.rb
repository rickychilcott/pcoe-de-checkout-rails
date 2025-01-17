require "rails_helper"

RSpec.describe CustomerPolicy, type: :policy do
  subject { described_class }

  permissions ".scope" do
    it "allows access to all admins for super_admin" do
      create(:customer)

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          Customer
        ).resolve
      ).to eq(Customer.all)
    end

    it "allows access to all admins for non-super_admin" do
      create(:customer)
      group = create(:group)

      expect(
        described_class::Scope.new(
          build(:admin_user, groups: [group]),
          Customer
        ).resolve
      ).to eq(Customer.all)
    end
  end

  permissions :index?, :show?, :create?, :update?, :destroy? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:customer))
    end

    it "allows access for non-super_admin" do
      group = create(:group)
      expect(subject).to permit(build(:admin_user, groups: [group]), build(:customer))
    end
  end

  permissions :act_on?, :show_pid?, :upload_csv_file? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), build(:customer))
    end

    it "denies access for non-super_admin" do
      group = create(:group)
      expect(subject).not_to permit(build(:admin_user, groups: [group]), build(:customer))
    end
  end
end
