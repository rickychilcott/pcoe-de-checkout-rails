class Process::Customer::BulkImport < ApplicationInteraction
  run_in_transaction!

  def self.csv_template
    CSV.generate do |csv|
      csv << Customer.importable_column_names
    end
  end

  file :csv_file
  object :imported_by, class: "AdminUser"
  validates :csv_file, presence: true

  def execute
    @resulting_customers = []

    clean_rows!
    conform_rows!
    update_and_create_customers!
    log_activities!

    resulting_customers
  end

  private

  attr_reader :resulting_customers, :existing_customers, :cleaned_rows

  def clean_rows!
    @cleaned_rows = []

    CSV.foreach(csv_file, headers: true) do |row|
      row_data = row.to_h.slice(*Customer.importable_column_names)

      @cleaned_rows << row_data
    end
  end

  def conform_rows!
    cleaned_rows.each do |row_data|
      row_data["role"] = role_by_name(row_data.delete("role"))

      row_data["notes"] = ConvertMarkdown.run!(text: row_data.delete("notes") || "")
    end
  end

  def group_by_name(name)
    return unless name.present?

    groups.find { it.name.strip == name.strip }
  end

  def update_and_create_customers!
    @resulting_customers =
      cleaned_rows.map do |row|
        Customer.find_or_initialize_by(ohio_id: row["ohio_id"]).tap do |customer|
          customer.assign_attributes(row)
        end
      end

    if resulting_customers.all?(&:valid?)
      resulting_customers.each(&:save!)
    else
      resulting_customers.each do |customer|
        next if customer.valid?

        errors.add(:base, customer.errors.full_messages.join(", "))
      end
    end
  end

  def role_by_name(name)
    return unless name.present?

    Customer.role.find_value(name.strip) ||
      Customer.role.options.find { |(text, value)| text.strip == name.strip }&.last
  end

  def errors? = errors.any?

  def log_activities!
    return if errors?

    resulting_customers.each do |customer|
      customer.record_activity!(
        :customer_bulk_import,
        actor: nil,
        facilitator: imported_by,
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
