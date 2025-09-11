require "rails_helper"

RSpec.describe Process::Item::BulkImport, type: :model do
  describe "imports" do
    it "can import" do
      admin_user = create(:admin_user)

      first_item = create(:item, id: 1, name: "Existing Item")
      expect(Location.count).to eq 1
      expect(Group.count).to eq 1
      expect(first_item.group.name).not_to eq("Default")
      expect(first_item.location.name).not_to eq("House")

      csv_file = File.open("spec/fixtures/files/items.csv")
      outcome = described_class.run(csv_file:, imported_by: admin_user)

      expect(outcome).to be_valid

      expect(Item.count).to eq 5
      expect(Location.count).to eq 3
      expect(Group.count).to eq 2

      # Creates New Item
      new_item = Item.find_by(name: "Item Without ID")
      expect(new_item.serial_number).to eq("a1111")
      expect(new_item.qr_code_identifier).to eq("a1111")
      expect(new_item.group.name).to eq("Default")
      expect(new_item.location.name).to eq("House")

      # Updates Existing Item
      first_item.reload
      expect(first_item.name).to eq("Item With ID")
      expect(first_item.serial_number).to eq("c1111")
      expect(first_item.qr_code_identifier).to eq("c1111")
      expect(first_item.group.name).to eq("Default")
      expect(first_item.location.name).to eq("House")
      expect(first_item.description.to_plain_text).to eq("RSPCS\n\nPatton 202B\n\n3-0812")

      # Allows Importing Parented Item
      parented_item = Item.find_by(name: "Parented Item")
      expect(parented_item.parent).to eq(first_item)
      expect(parented_item.serial_number).to eq("d1111")
      expect(parented_item.qr_code_identifier).to eq("d1111")
      expect(parented_item.group.name).to eq("Default")
      expect(parented_item.location.name).to eq("House")

      expect(Location.exists?(name: "Another")).to be_truthy
    end

    it "nutso import" do
      admin_user = create(:admin_user)

      customer = create(:customer, ohio_id: "adamsw1", name: "Adam Swanson", role: "faculty_staff")

      csv_file = File.open("spec/fixtures/files/big-items-import.csv")
      outcome = described_class.run(csv_file:, imported_by: admin_user, default_return_date: 1.month.from_now.to_date)

      expect(outcome).to be_valid

      expect(outcome.resulting_items.size).to eq 356
      expect(outcome.resulting_checkouts.size).to eq 2

      expect(Item.count).to eq 356
      expect(Checkout.count).to eq 2

      last_checkout = Checkout.last
      expect(last_checkout.customer).to eq(customer)
      expect(last_checkout.item.name).to eq("Key 15B1-12")
      expect(last_checkout.expected_return_on.to_date).to eq(Date.parse("2028-05-14"))

      first_checkout = Checkout.first
      expect(first_checkout.customer).to eq(customer)
      expect(first_checkout.item.name).to eq("Key 15B8-3")
      expect(first_checkout.expected_return_on).to eq(1.month.from_now.to_date)
    end

    xit "another nutso import" do
      admin_user = create(:admin_user)

      csv_file = File.open("spec/fixtures/files/big-items-import-2.csv")
      outcome = described_class.run(csv_file:, imported_by: admin_user, default_return_date: 1.month.from_now.to_date)

      expect(outcome).to be_valid

      expect(outcome.resulting_items.size).to eq 356
      expect(outcome.resulting_checkouts.size).to eq 2

      expect(Item.count).to eq 113
      expect(Checkout.count).to eq 0

      last_checkout = Checkout.last
      expect(last_checkout.customer).to eq(customer)
      expect(last_checkout.item.name).to eq("Key 15B1-12")
      expect(last_checkout.expected_return_on.to_date).to eq(Date.parse("2028-05-14"))

      first_checkout = Checkout.first
      expect(first_checkout.customer).to eq(customer)
      expect(first_checkout.item.name).to eq("Key 15B8-3")
      expect(first_checkout.expected_return_on).to eq(1.month.from_now.to_date)
    end
  end
end
