class BadgeComponent < ApplicationComponent
  prop :label, String, reader: :private
  prop :count, Integer, reader: :private
  prop :button_variant, BsVariant, reader: :private
  prop :badge_variant, BsVariant, default: BsVariant::Secondary, reader: :private
  prop :text_variant, BsVariant, default: BsVariant::Dark, reader: :private

  def view_template
    span(class: "inline-flex items-center gap-1.5 rounded-md px-3 py-1.5 text-sm font-medium cursor-default #{button_variant.bg_class}") do
      span(class: text_variant.text_class) { label }
      span(class: "rounded-full px-2 py-0.5 text-xs font-semibold #{badge_variant.bg_class}") { count }
    end
  end
end
