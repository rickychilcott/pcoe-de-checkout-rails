class Items::CheckoutsController < ApplicationController
  def new
    item = resolved_policy_scope(Item).find(params[:item_id])
    available_items = resolved_policy_scope(Item).not_checked_out

    render locals: {item:, available_items:}
  end

  def create
  end
end
