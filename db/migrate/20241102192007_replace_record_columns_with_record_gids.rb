class ReplaceRecordColumnsWithRecordGids < ActiveRecord::Migration[7.2]
  def up
    # Add new column
    add_column :activities, :record_gids, :jsonb, null: false, default: []
    add_index :activities, :record_gids, using: :gin

    # Migrate existing data with a single SQL update
    app_name = Rails.application.engine_name
    execute <<-SQL
      UPDATE activities
      SET record_gids = json('[' ||
        '"gid://#{app_name}/' || record_type || '/' || record_id || '"' ||
      ']')
      WHERE record_type IS NOT NULL AND record_id IS NOT NULL
    SQL

    # Remove old polymorphic columns and index
    remove_index :activities, name: :index_activities_on_record
    remove_column :activities, :record_type, :string
    remove_column :activities, :record_id, :integer
  end

  def down
    # Add back the polymorphic columns
    add_column :activities, :record_type, :string
    add_column :activities, :record_id, :integer
    add_index :activities, [:record_type, :record_id], name: :index_activities_on_record

    # Simplified SQL for SQLite compatibility
    execute <<-SQL
      UPDATE activities
      SET
        record_type = (
          SELECT
            substr(
              value,
              instr(value, '/') + 2,
              instr(substr(value, instr(value, '/') + 2), '/') - 1
            )
          FROM json_each(record_gids)
          WHERE key = 0
        ),
        record_id = (
          SELECT
            CAST(
              trim(
                substr(
                  substr(value, instr(value, '/') + 2),
                  instr(substr(value, instr(value, '/') + 2), '/') + 1
                ),
                '"'
              ) AS INTEGER
            )
          FROM json_each(record_gids)
          WHERE key = 0
        )
      WHERE json_array_length(record_gids) > 0
    SQL

    # Remove the new column
    remove_index :activities, :record_gids
    remove_column :activities, :record_gids, :jsonb
  end
end
