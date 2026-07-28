require "rails_helper"

RSpec.describe "Bravo AdminUsers", type: :request do
  let(:super_admin) { create(:admin_user, :super_admin) }
  let(:admin) { create(:admin_user) }

  describe "authentication" do
    it "hides the admin from signed-out visitors" do
      get "/admin/resources/admin_users"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /admin/resources/admin_users (index)" do
    it "lists admin users" do
      sign_in super_admin
      other = create(:admin_user, name: "Findable Admin")

      get bravo_resources_path("admin_users")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Findable Admin")
      expect(response.body).to include(other.email)
    end

    it "is visible to non-super admins" do
      sign_in admin

      get bravo_resources_path("admin_users")

      expect(response).to have_http_status(:ok)
    end

    it "searches by name or email" do
      sign_in super_admin
      create(:admin_user, name: "Alpha Person", email: "alpha@example.com")
      create(:admin_user, name: "Beta Person", email: "beta@example.com")

      get bravo_resources_path("admin_users", q: "alpha")

      expect(response.body).to include("Alpha Person")
      expect(response.body).not_to include("Beta Person")
    end

    it "sorts by name" do
      sign_in super_admin
      create(:admin_user, name: "Zed")
      create(:admin_user, name: "Abel")

      get bravo_resources_path("admin_users", sort: "name", dir: "asc")

      expect(response.body.index("Abel")).to be < response.body.index("Zed")
    end
  end

  describe "GET /admin/resources/admin_users/:id (show)" do
    it "shows the admin user with their groups" do
      sign_in super_admin
      group = create(:group, name: "AV Gear")
      admin.groups << group

      get bravo_resource_path("admin_users", admin)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(admin.name)
      expect(response.body).to include("AV Gear")
    end
  end

  describe "POST /admin/resources/admin_users (create)" do
    it "creates an admin user as a super admin" do
      sign_in super_admin
      group = create(:group)

      expect do
        post bravo_resources_path("admin_users"), params: {
          admin_user: {
            name: "New Admin",
            email: "new-admin@example.com",
            password: "secret-password-123",
            password_confirmation: "secret-password-123",
            super_admin: "1",
            group_ids: [group.id]
          }
        }
      end.to change(AdminUser, :count).by(1)

      new_admin = AdminUser.find_by!(email: "new-admin@example.com")
      expect(new_admin.super_admin).to be true
      expect(new_admin.groups).to contain_exactly(group)
      expect(response).to redirect_to(bravo_resource_path("admin_users", new_admin))
    end

    it "re-renders with errors when invalid" do
      sign_in super_admin

      expect do
        post bravo_resources_path("admin_users"), params: {
          admin_user: {name: "", email: "", password: "short"}
        }
      end.not_to change(AdminUser, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("error")
    end

    it "forbids non-super admins" do
      sign_in admin

      expect do
        post bravo_resources_path("admin_users"), params: {
          admin_user: {name: "Sneaky", email: "sneaky@example.com", password: "secret-password-123"}
        }
      end.not_to change(AdminUser, :count)

      expect(response).to redirect_to(bravo_root_path)
    end
  end

  describe "PATCH /admin/resources/admin_users/:id (update)" do
    it "updates attributes, ignoring a blank password" do
      sign_in super_admin
      target = create(:admin_user, name: "Old Name")

      patch bravo_resource_path("admin_users", target), params: {
        admin_user: {name: "New Name", email: target.email, password: "", password_confirmation: ""}
      }

      expect(response).to redirect_to(bravo_resource_path("admin_users", target))
      expect(target.reload.name).to eq("New Name")
    end

    it "changes the password when one is provided" do
      sign_in super_admin
      target = create(:admin_user)

      patch bravo_resource_path("admin_users", target), params: {
        admin_user: {name: target.name, email: target.email, password: "brand-new-pass-1", password_confirmation: "brand-new-pass-1"}
      }

      expect(target.reload.valid_password?("brand-new-pass-1")).to be true
    end

    it "updates group membership from checkboxes" do
      sign_in super_admin
      keep, drop = create(:group), create(:group)
      target = create(:admin_user, groups: [drop])

      patch bravo_resource_path("admin_users", target), params: {
        admin_user: {name: target.name, email: target.email, group_ids: [keep.id]}
      }

      expect(target.reload.groups).to contain_exactly(keep)
    end

    it "forbids non-super admins" do
      sign_in admin
      target = create(:admin_user, name: "Untouchable")

      patch bravo_resource_path("admin_users", target), params: {
        admin_user: {name: "Hacked"}
      }

      expect(response).to redirect_to(bravo_root_path)
      expect(target.reload.name).to eq("Untouchable")
    end

    it "does not let a non-super admin grant super_admin through mass assignment" do
      sign_in admin

      patch bravo_resource_path("admin_users", admin), params: {
        admin_user: {name: admin.name, super_admin: "1"}
      }

      expect(admin.reload.super_admin).to be false
    end
  end

  describe "DELETE /admin/resources/admin_users/:id (destroy)" do
    it "destroys the admin user as a super admin" do
      sign_in super_admin
      target = create(:admin_user)

      expect do
        delete bravo_resource_path("admin_users", target)
      end.to change(AdminUser, :count).by(-1)

      expect(response).to redirect_to(bravo_resources_path("admin_users"))
    end

    it "forbids non-super admins" do
      sign_in admin
      target = create(:admin_user)

      expect do
        delete bravo_resource_path("admin_users", target)
      end.not_to change(AdminUser, :count)
    end
  end

  describe "actions authorization" do
    it "forbids non-super admins from running resource actions" do
      sign_in admin

      post bravo_resource_action_path("customers", "import_customers"), params: {fields: {}}

      expect(response).to redirect_to(bravo_root_path)
      expect(flash[:alert]).to include("not authorized")
    end

    it "runs the customer import for super admins" do
      sign_in super_admin

      expect do
        post bravo_resource_action_path("customers", "import_customers"), params: {
          fields: {csv_file: fixture_file_upload("customers.csv", "text/csv")}
        }
      end.to change(Customer, :count).by(5)

      expect(response).to redirect_to(bravo_resources_path("customers"))
      expect(flash[:notice]).to include("5 customers imported successfully")
    end
  end
end
