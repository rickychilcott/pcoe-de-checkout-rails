require "rails_helper"

RSpec.describe "Bravo Customers", type: :request do
  describe "GET /admin/resources/customers" do
    it "filters by role" do
      sign_in create(:admin_user, :super_admin)

      student = create(:customer, role: :student)
      staff = create(:customer, role: :faculty_staff)

      get bravo_resources_path("customers", filters: {customer_role_filter: "faculty_staff"})

      page_text = Nokogiri::HTML(response.body).text
      expect(page_text).to include(staff.name)
      expect(page_text).not_to include(student.name)
    end

    it "filters by name, email, ohio id, and pid" do
      sign_in create(:admin_user, :super_admin)

      match = create(:customer, name: "Jamie Doe", ohio_id: "jd123456", pid: "P123456789")
      other = create(:customer)

      get bravo_resources_path("customers", filters: {name: "Jamie"})
      expect(Nokogiri::HTML(response.body).text).to include(match.name)

      get bravo_resources_path("customers", filters: {customer_email_filter: "jd123456@ohio.edu"})
      expect(Nokogiri::HTML(response.body).text).to include(match.name)

      get bravo_resources_path("customers", filters: {ohio_id: "jd123456"})
      expect(Nokogiri::HTML(response.body).text).to include(match.name)

      get bravo_resources_path("customers", filters: {pid: "P123456789"})
      page_text = Nokogiri::HTML(response.body).text
      expect(page_text).to include(match.name)
      expect(page_text).not_to include(other.name)
    end

    it "filters by checked out and past due item count ranges, keeping zero-count customers when 0 is in range" do
      sign_in create(:admin_user, :super_admin)

      busy = create(:customer)
      create(:checkout, customer: busy)
      create(:checkout, customer: busy, expected_return_on: 2.days.ago.to_date)

      idle = create(:customer)

      get bravo_resources_path("customers", filters: {
        customer_checked_out_count_filter_min: 2,
        customer_checked_out_count_filter_max: 2
      })
      page_text = Nokogiri::HTML(response.body).text
      expect(page_text).to include(busy.name)
      expect(page_text).not_to include(idle.name)

      get bravo_resources_path("customers", filters: {customer_past_due_count_filter_min: 1})
      page_text = Nokogiri::HTML(response.body).text
      expect(page_text).to include(busy.name)
      expect(page_text).not_to include(idle.name)

      get bravo_resources_path("customers", filters: {
        customer_checked_out_count_filter_min: 0,
        customer_checked_out_count_filter_max: 0
      })
      page_text = Nokogiri::HTML(response.body).text
      expect(page_text).to include(idle.name)
      expect(page_text).not_to include(busy.name)
    end
  end
end
