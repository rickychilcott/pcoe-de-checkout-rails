class CreateCheckouts < ActiveRecord::Migration[7.2]
  def change
    create_table :checkouts do |t|
      t.belongs_to :item, null: false, foreign_key: true
      t.belongs_to :customer, null: false, foreign_key: true

      t.belongs_to :checked_out_by, null: false, foreign_key: {to_table: :admin_users}
      t.datetime :checked_out_at

      t.datetime :returned_at
      t.belongs_to :returned_by, null: false, foreign_key: {to_table: :admin_users}

      t.date :expected_return_on

      t.timestamps
    end
  end
end
