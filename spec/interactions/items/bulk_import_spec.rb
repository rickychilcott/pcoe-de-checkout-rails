require "rails_helper"

RSpec.describe Item::Process::BulkImport, type: :model do
  describe "imports" do
    it "can import" do
      admin_user = FactoryBot.create(:admin_user)

      FactoryBot.create(:item, id: 1, name: "Existing Item")
      expect(Location.count).to eq 1
      expect(Group.count).to eq 1
      first_item = Item.find(1)
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

      # Allows Importing Parented Item
      parented_item = Item.find_by(name: "Parented Item")
      expect(parented_item.parent).to eq(first_item)
      expect(parented_item.serial_number).to eq("d1111")
      expect(parented_item.qr_code_identifier).to eq("d1111")
      expect(parented_item.group.name).to eq("Default")
      expect(parented_item.location.name).to eq("House")

      expect(Location.exists?(name: "Another")).to be_truthy
    end
  end
end
