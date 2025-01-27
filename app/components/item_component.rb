class ItemComponent < ApplicationComponent
  include Phlex::Rails::Helpers::CheckBoxTag
  prop :item, Item, reader: :private

  def view_template
    checkbox
    link
  end

  private

  def checkbox
    check_box_tag("item_ids[]", item_id, false, id: checkbox_name)
  end

  def link
    label(for: checkbox_name) do
      link_to(item_path(item), data: {turbo_frame: "_top"}, class: "ps-2") do
        plain item_name
      end
    end
  end

  def checkbox_name
    dom_id(item, :checkout)
  end

  delegate :id, :name, to: :item, prefix: true
end
