class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :serial_number
      t.belongs_to :parent_item, foreign_key: {to_table: :items}
      t.belongs_to :location, foreign_key: true
      t.string :qr_code_identifier
      t.belongs_to :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
