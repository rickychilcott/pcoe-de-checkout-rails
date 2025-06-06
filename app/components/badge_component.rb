class BadgeComponent < ApplicationComponent
  prop :label, String, reader: :private
  prop :count, Integer, reader: :private
  prop :button_variant, BsVariant, reader: :private
  prop :badge_variant, BsVariant, default: BsVariant::Secondary, reader: :private
  prop :text_variant, BsVariant, default: BsVariant::Dark, reader: :private

  def view_template
    span(class: "btn #{button_variant.bg_class} cursor-default") do
      span(class: text_variant.text_class) { label }
      span(class: "ms-1 badge #{badge_variant.bg_class}") { count }
    end
  end
end
