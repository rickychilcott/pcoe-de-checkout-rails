require "rails_helper"

RSpec.describe CheckoutPolicy, type: :policy do
  let(:group) { create(:group) }

  subject { described_class }

  permissions ".scope" do
    it "allows access to all items for super_admin" do
      create(:checkout)

      expect(
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          Checkout
        ).resolve
      ).to eq(Checkout.all)
    end

    it "allows access to group checkouts for non-super_admin" do
      user = create(:admin_user, groups: [group])
      item = create(:item, group:)
      checkout_1 = create(:checkout, item:)
      _checkout_2 = create(:checkout)

      expect(
        described_class::Scope.new(
          user, Checkout
        ).resolve
      ).to eq([checkout_1])
    end
  end

  permissions :index?, :show?, :return? do
    it "allows access for super_admin" do
      item = build(:item, group:)
      expect(subject).to permit(build(:admin_user, :super_admin), build(:checkout, item:))
    end

    it "allows access for non-super_admin" do
      item = build(:item, group:)
      expect(subject).to permit(build(:admin_user, groups: [group]), build(:checkout, item:))
    end
  end

  permissions :create?, :update?, :destroy? do
    it "denies access for super_admin" do
      item = build(:item, group:)
      expect(subject).not_to permit(build(:admin_user, :super_admin), build(:checkout, item:))
    end

    it "denies access for checkouts" do
      item = build(:item, group:)
      expect(subject).not_to permit(build(:admin_user, groups: [group]), build(:checkout, item:))
    end
  end
end
