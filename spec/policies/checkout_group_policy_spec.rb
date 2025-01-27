require "rails_helper"

RSpec.describe CheckoutGroupPolicy, type: :policy do
  let(:group) { create(:group) }

  subject { described_class }

  permissions ".scope" do
    it "allows access to all items for super_admin" do
      create(:checkout)

      expect {
        described_class::Scope.new(
          build(:admin_user, :super_admin),
          Checkout
        ).resolve
      }.to raise_error(NotImplementedError)
    end

    it "allows access to group checkouts for non-super_admin" do
      user = create(:admin_user, groups: [group])
      item = create(:item, group:)
      checkout_1 = create(:checkout, item:)
      _checkout_2 = create(:checkout)

      expect {
        described_class::Scope.new(
          user, Checkout
        ).resolve
      }.to raise_error(NotImplementedError)
    end
  end

  permissions :index?, :show?, :create? do
    it "allows access for super_admin" do
      expect(subject).to permit(build(:admin_user, :super_admin), CheckoutGroup.new(items: create_list(:item, 2, group:)))
    end

    it "allows access for non-super_admin" do
      expect(subject).to permit(build(:admin_user, groups: [group]), CheckoutGroup.new(items: create_list(:item, 2, group:)))
    end

    it "disallows access for non-super_admin not in group" do
      expect(subject).not_to permit(build(:admin_user, groups: []), CheckoutGroup.new(items: create_list(:item, 2, group:)))
    end
  end

  permissions :update?, :destroy? do
    it "denies access for super_admin" do
      items = create_list(:item, 2, group:)

      expect(subject).not_to permit(build(:admin_user, :super_admin), CheckoutGroup.new(items:))
      expect(subject).not_to permit(build(:admin_user, groups: [group]), CheckoutGroup.new(items:))
      expect(subject).not_to permit(build(:admin_user, groups: []), CheckoutGroup.new(items:))
    end
  end
end
