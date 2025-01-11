class AddPidToCustomer < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :pid, :string, null: true
    add_index :customers, :pid, unique: true
  end
end
