class Customers::CheckoutsController < ApplicationController
  before_action :authenticate_admin_user!

  def create
    customer = Customer.find(params[:customer_id])
    items = resolved_policy_scope(Item).where(id: params[:item_ids])

    authorize CheckoutGroup.new(items:), :create?

    Process::ItemGroup::Checkout.run!(
      customer:,
      items:,
      checked_out_by: current_admin_user,
      expected_return_on: params[:expected_return_on]
    )

    flash[:notice] = "#{items.size} #{"Item".pluralize(items.size)} checked out to #{customer.title}"

    respond_to do |format|
      format.html { redirect_to customer_path(customer), status: :see_other }
      format.turbo_stream do
        render turbo_stream: turbo_stream.redirect_to(customer_path(customer))
      end
    end
  end
end
