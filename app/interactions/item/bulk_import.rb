class Item::BulkImport < ApplicationInteraction
  run_in_transaction!

  def self.csv_template
    CSV.generate do |csv|
      csv << Item.importable_column_names
    end
  end

  file :csv_file
  validates :csv_file, presence: true

  def execute
    @resulting_items = []

    clean_rows!
    build_locations!
    build_groups!
    find_items!
    conform_rows!
    update_and_create_items!
    log_activities!

    resulting_items
  end

  private

  attr_reader :resulting_items, :existing_items, :cleaned_rows, :locations, :groups

  def clean_rows!
    @cleaned_rows = []

    CSV.foreach(csv_file, headers: true) do |row|
      row_data = row.to_h.slice(*Item.importable_column_names)

      @cleaned_rows << row_data
    end
  end

  def build_locations!
    @locations = []

    cleaned_rows
      .map { _1["location_name"].strip }
      .compact
      .uniq
      .each { |name| @locations << Location.find_or_create_by!(name:) }
  end

  def location_by_name(name)
    return unless name.present?

    locations.find { _1.name.strip == name.strip }
  end

  def build_groups!
    @groups = []

    cleaned_rows
      .map { _1["group_name"].strip }
      .compact
      .uniq
      .each { |name| @groups << Group.find_or_create_by!(name:) }
  end

  def group_by_name(name)
    return unless name.present?

    groups.find { _1.name.strip == name.strip }
  end

  def find_items!
    ids = [
      *cleaned_rows.map { _1["id"] },
      *cleaned_rows.map { _1["parent_item_id"] }
    ].compact.uniq

    @existing_items = Item.where(id: ids)
  end

  def item_by_id(id)
    return unless id.present?

    existing_items.find { _1.id == id.to_i }
  end

  def conform_rows!
    cleaned_rows.each do |row_data|
      row_data["location"] = location_by_name(row_data.delete("location_name"))
      row_data["group"] = group_by_name(row_data.delete("group_name"))
      row_data["parent"] = item_by_id(row_data.delete("parent_item_id"))
    end
  end

  def update_and_create_items!
    updating_items, new_items = cleaned_rows.partition { _1["id"].present? }

    updating_items.each do |row_data|
      id = row_data["id"]

      unless (item = item_by_id(id))
        errors.add(:base, "Item with ID #{id} not found")
        next
      end
      item.update!(row_data)
      @resulting_items << item
    end

    new_items.each do |row_data|
      @resulting_items <<
        Item.create!(
          row_data.without("id")
        )
    end
  end

  def log_activities!
    resulting_items.each do |item|
      item.record_activity!(
        :item_bulk_import,
        actor: nil,
        extra: {
          import_identifier:
        }
      )
    end
  end

  def import_identifier
    @import_identifier ||= "import-#{SecureRandom.uuid}"
  end
end
