# app/components/admin_links_component.rb
class AdminLinksComponent < ApplicationComponent
  prop :admin_user, _Nilable(AdminUser), reader: :private

  def render? = admin_user.present?

  def view_template
    div(class: "flex items-stretch gap-2") do
      link_to(root_path, class: "flex items-center rounded-md bg-primary-600 text-white px-3 hover:bg-primary-700") do
        render(PhlexIcons::Bootstrap::HouseFill.new)
      end

      link_to("Sign out as #{admin_user.name}",
        destroy_admin_user_session_path,
        data: {turbo_method: :delete, turbo_confirm: "Are you sure you want to sign out?"},
        class: "flex-1 flex items-center justify-center rounded-md border border-gray-300 bg-white px-3 py-2 text-sm font-medium text-gray-600 hover:bg-gray-50")

      link_to(bravo_root_path, id: "bravo-link", class: "flex items-center rounded-md bg-amber-400 text-gray-900 px-3 hover:bg-amber-500") do
        render(PhlexIcons::Bootstrap::Gear.new)
      end
    end
  end
end
