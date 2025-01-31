class CartController < ApplicationController
  def add_items
    items = resolved_policy_scope(Item).where(id: params[:item_ids])

    authorize CheckoutGroup.new(items:), :new?

    respond_to do |format|
      format.turbo_stream do
        html =
          render_to_string(
            RemovableItemComponent.new(item: items.first),
            layout: false
          )

        render turbo_stream: turbo_stream.append(params["replacement_target"], html)
      end
    end
  end

  def remove_items
    items = resolved_policy_scope(Item).where(id: params[:item_ids])

    authorize CheckoutGroup.new(items:), :new?

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(params["replacement_target"])
      end
    end
  end
end
