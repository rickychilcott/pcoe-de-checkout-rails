class Items::CheckoutsController < ApplicationController
  def new
    item =
      Item
        .resolved_policy_scope_for(current_admin_user)
        .find(params[:item_id])

    available_items =
      Item
        .resolved_policy_scope_for(current_admin_user)
        .not_checked_out

    render locals: {item:, available_items:}
  end

  def create
  end
end
