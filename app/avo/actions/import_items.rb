class Avo::Actions::ImportItems < Avo::BaseAction
  self.name = "Import Items"
  self.message = -> do
    <<~MESSAGE
      <span>
        Use this to import items from a CSV file.
        You may download the #{link_to("CSV Template", avo.import_items_download_template_path(format: :csv))} to get started.
      </span>
    MESSAGE
      .html_safe
  end
  self.standalone = true
  self.visible = -> { view == :index }
  self.confirm_button_label = "Import"

  def fields
    field :csv_file, as: :file
    field :default_return_date, as: :date, default: -> { 1.month.from_now.to_date }
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    outcome =
      Process::Item::BulkImport
        .run(
          csv_file: fields[:csv_file],
          imported_by: current_user,
          default_return_date: fields[:default_return_date]
        )

    if outcome.valid?
      success_message = "#{outcome.resulting_items.size} items imported successfully"
      success_message += " and #{outcome.resulting_checkouts.size} checkouts created successfully" if outcome.resulting_checkouts.any?
      succeed success_message
      close_modal
    else
      error "Error: #{outcome.errors.full_messages.join(", ")}"
    end
  end
end
