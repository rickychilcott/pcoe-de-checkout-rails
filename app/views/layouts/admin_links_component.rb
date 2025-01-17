# app/components/admin_links_component.rb
class AdminLinksComponent < ApplicationComponent
  prop :admin_user, _Nilable(AdminUser), reader: :private

  def render? = admin_user.present?

  def view_template
    div(class: "row my-4") do
      div(class: "col-auto") do
        link_to(root_path, class: "btn btn-primary") do
          render(PhlexIcons::Bootstrap::HouseFill.new)
        end
      end

      div(class: "col") do
        link_to("Log out as #{admin_user.name}",
          destroy_admin_user_session_path,
          data: {turbo_method: :delete, turbo_confirm: "Are you sure you want to log out?"},
          class: "btn btn-secondary w-100")
      end

      div(class: "col-auto") do
        link_to(avo_path, id: "avo-link", class: "btn btn-warning") do
          render(PhlexIcons::Bootstrap::Gear.new)
        end
      end
    end
  end
end
