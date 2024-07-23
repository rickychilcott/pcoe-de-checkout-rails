class Avo::Actions::ImportItems < Avo::BaseAction
  self.name = "Import Items"
  self.message = -> do
    <<~MESSAGE
      <span>
        Use this to import items from a CSV file. You may download the #{link_to("CSV Template", avo.import_items_download_template_path(format: :csv))} to get started.
      </span>
    MESSAGE
      .html_safe
  end
  self.standalone = true
  self.visible = -> { view == :index }
  self.confirm_button_label = "Import"

  def fields
    field :csv_file, as: :file
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    outcome = Item::BulkImport.run(csv_file: fields[:csv_file])

    if outcome.valid?
      succeed "#{outcome.result.size} items imported successfully"
    else
      error "Error: #{outcome.errors.full_messages.join(", ")}"
    end
  end
end
