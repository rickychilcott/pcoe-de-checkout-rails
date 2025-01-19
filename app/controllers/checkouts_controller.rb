class CheckoutsController < ApplicationController
  def index
    checkouts =
      resolved_policy_scope(Checkout)
        .includes(:checked_out_by, :item)
        .past_due
        .or(Checkout.due_today)
        .order(expected_return_on: :asc)

    render :index, locals: {checkouts:}
  end
end
