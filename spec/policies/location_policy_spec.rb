require "rails_helper"

RSpec.describe LocationPolicy, type: :policy do
  subject { described_class }

  permissions ".scope" do
    it "allows access to all locations for super_admin" do
      create(:location)

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          Location
        ).resolve
      ).to eq(Location.all)
    end

    it "allows access to all locations for non-super_admin" do
      create(:location)

      expect(
        described_class::Scope.new(
          build(:admin_user), Location
        ).resolve
      ).to eq(Location.all)
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
