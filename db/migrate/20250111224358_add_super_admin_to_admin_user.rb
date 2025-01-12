class AddSuperAdminToAdminUser < ActiveRecord::Migration[7.2]
  def change
    add_column :admin_users, :super_admin, :boolean, null: false, default: false
  end
end
