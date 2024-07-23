class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.references :actor, foreign_key: {to_table: :customers}
      t.references :facilitator, null: false, foreign_key: {to_table: :admin_users}
      t.string :action, null: false, index: true
      t.references :record, polymorphic: true, null: true

      t.json :extra, null: false, default: {}

      t.datetime :occurred_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
