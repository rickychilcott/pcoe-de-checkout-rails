class Avo::ToolsController < Avo::ApplicationController
  def import_items_download_template
    respond_to do |format|
      format.csv do
        send_data Item::BulkImport.csv_template, filename: "item-import-template.csv"
      end
    end
  end
end
