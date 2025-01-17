class RemoveNullFromPid < ActiveRecord::Migration[7.2]
  def change
    change_column_null :customers, :pid, true
  end
end
