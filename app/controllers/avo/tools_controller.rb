class Avo::ToolsController < Avo::ApplicationController
  def import_items_download_template
    respond_to do |format|
      format.csv do
        send_data Item::BulkImport.csv_template, filename: "item-import-template.csv"
      end
    end
  end

  def past_due
    @page_title = "Past Due Checkouts"
    add_breadcrumb "Past Due Checkouts"

    checkouts = Checkout.includes(:customer, :item).past_due

    render "avo/tools/checkouts", locals: {checkouts:}
  end

  def checked_out
    @page_title = "Current Checkouts"
    add_breadcrumb "Current Checkouts"
    checkouts = Checkout.includes(:customer, :item).checked_out

    render "avo/tools/checkouts", locals: {checkouts:}
  end
end