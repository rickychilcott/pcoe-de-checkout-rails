class CheckoutsController < ApplicationController
  def index
    checkouts =
      resolved_policy_scope(Checkout)
        .includes(:checked_out_by, :item, :customer)
        .order(expected_return_on: :asc)

    checkouts =
      if only_past_due?
        checkouts.past_due
      else
        checkouts.checked_out
      end

    # one query for every row's "N items out" badge
    items_out_counts =
      resolved_policy_scope(Checkout)
        .checked_out
        .where(customer_id: checkouts.map(&:customer_id).uniq)
        .group(:customer_id)
        .count

    render :index, locals: {checkouts:, items_out_counts:}
  end

  def show
    checkout = resolved_policy_scope(Checkout).find(params[:id])
    redirect_to item_path(checkout.item)
  end

  private

  helper_method def only_past_due?
    params[:only_past_due].present?
  end
end
