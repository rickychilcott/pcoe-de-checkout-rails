class Avo::ToolsController < Avo::ApplicationController
  def import_customers_download_template
    respond_to do |format|
      format.csv do
        send_data Process::Customer::BulkImport.csv_template, filename: "customer-import-template.csv"
      end
    end
  end

  def import_items_download_template
    respond_to do |format|
      format.csv do
        send_data Process::Item::BulkImport.csv_template, filename: "item-import-template.csv"
      end
    end
  end
end
