class CheckoutsController < ApplicationController
  def index
    checkouts =
      resolved_policy_scope(Checkout)
        .includes(:checked_out_by, :item)
        .order(expected_return_on: :asc)

    checkouts =
      if only_past_due?
        checkouts.past_due
      else
        checkouts.checked_out
      end

    render :index, locals: {checkouts:}
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
