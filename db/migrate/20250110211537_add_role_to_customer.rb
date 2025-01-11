class AddRoleToCustomer < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :role, :string, default: "student", null: false
  end
end
