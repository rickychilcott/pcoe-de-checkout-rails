class Customers::ReturnsController < ApplicationController
  before_action :authenticate_admin_user!

  def create
    customer = Customer.find(params[:customer_id])
    checkouts = resolved_policy_scope(Checkout).where(id: params[:checkout_ids], customer:)

    checkouts.each { authorize it, :return? }

    Process::Checkouts::Return.run!(
      customer:,
      checkouts:,
      returned_by: current_admin_user
    )

    flash[:notice] = "#{checkouts.size} #{"Item".pluralize(checkouts.size)} returned for #{customer.name}"

    respond_to do |format|
      format.html { redirect_to customer_path(customer), status: :see_other }
      format.turbo_stream do
        render turbo_stream: turbo_stream.redirect_to(customer_path(customer))
      end
    end
  end
end
