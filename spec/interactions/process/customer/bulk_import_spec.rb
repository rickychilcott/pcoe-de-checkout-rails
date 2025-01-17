require "rails_helper"

RSpec.describe Process::Customer::BulkImport, type: :model do
  describe "imports" do
    it "can import" do
      admin_user = create(:admin_user, :super_admin)

      existing_customer = create(:customer, name: "Existing Customer", ohio_id: "aa111111")

      csv_file = File.open("spec/fixtures/files/customers.csv")
      outcome = described_class.run(csv_file:, imported_by: admin_user)

      expect(outcome).to be_valid

      expect(Customer.count).to eq 5

      # Updates Existing Customer
      existing_customer.reload
      expect(existing_customer.name).to eq("Customer With Ohio ID")
      expect(existing_customer.role).to eq("student")
      expect(existing_customer.ohio_id).to eq("aa111111")
      expect(existing_customer.pid).to eq("P000000001")

      # Creates New Customer
      new_customer = Customer.find_by(ohio_id: "bb222222")
      expect(new_customer.name).to eq("Another Customer With Ohio ID")
      expect(new_customer.role).to eq("student")
      expect(new_customer.ohio_id).to eq("bb222222")
      expect(new_customer.pid).to eq("P000000002")

      # Allows Importing Faculty/Staff customer
      faculty_staff_customer = Customer.find_by(ohio_id: "dd444444")
      expect(faculty_staff_customer.name).to eq("Faculty/Staff Customer")
      expect(faculty_staff_customer.role).to eq("faculty_staff")
      expect(faculty_staff_customer.ohio_id).to eq("dd444444")
      expect(faculty_staff_customer.pid).to eq(nil)
    end

    it "handles errors import" do
      admin_user = create(:admin_user, :super_admin)

      csv_file = File.open("spec/fixtures/files/bad_customers.csv")
      outcome = described_class.run(csv_file:, imported_by: admin_user)

      expect(outcome).not_to be_valid

      expect(Customer.count).to eq 0
    end
  end
end
