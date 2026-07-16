class RemovableItemComponent < ApplicationComponent
  include Phlex::Rails::Helpers::HiddenFieldTag

  prop :item, Item, reader: :private

  def view_template
    div(id: item_dom_id) do
      hidden_field
      add_link
      remove_link
    end
  end

  private

  def hidden_field
    hidden_field_tag("item_ids[]", item_id)
  end

  def add_link
    link_to(item_path(item), data: {turbo_frame: "_top"}, class: "pl-2 text-primary-600 hover:underline") do
      plain item_name
    end
  end

  def remove_link
    link_to(remove_url, method: :delete, data: {turbo_method: :delete}, class: "pl-2 text-primary-600 hover:underline") do
      render PhlexIcons::Bootstrap::TrashFill.new
    end
  end

  def remove_url
    cart_remove_items_path(item_ids: [item.id], replacement_target: item_dom_id, format: :turbo_stream)
  end

  def item_dom_id
    dom_id(item)
  end

  delegate :id, :name, to: :item, prefix: true
end
