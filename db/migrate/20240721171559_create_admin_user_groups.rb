class CreateAdminUserGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :admin_user_groups do |t|
      t.belongs_to :admin_user, null: false, foreign_key: true
      t.belongs_to :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
