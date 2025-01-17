class Avo::Actions::ImportCustomers < Avo::BaseAction
  self.name = "Import Customers"
  self.message = -> do
    <<~MESSAGE
      <span>
        Use this to import customers from a CSV file.
        You may download the #{link_to("CSV Template", avo.import_customers_download_template_path(format: :csv))} to get started.<br><br>
        Note that the 'role' column should contain either 'student' or 'faculty_staff'.<br>
        'PID' is only required for students.<br>
        All other columns are required.
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
    outcome = Process::Customer::BulkImport.run(csv_file: fields[:csv_file], imported_by: current_user)

    if outcome.valid?
      succeed "#{outcome.result.size} customers imported successfully"
      close_modal
    else
      error "Error: #{outcome.errors.full_messages.join(", ")}"
    end
  end
end
