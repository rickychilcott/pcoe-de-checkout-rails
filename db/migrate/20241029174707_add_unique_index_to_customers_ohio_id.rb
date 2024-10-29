class AddUniqueIndexToCustomersOhioId < ActiveRecord::Migration[7.2]
  def change
    add_index :customers, :ohio_id, unique: true
  end
end
