class AlertComponent < ApplicationComponent
  prop :label, String, reader: :private
  prop :bg_variant, BsVariant, default: BsVariant::Secondary, reader: :private
  prop :text_variant, BsVariant, default: BsVariant::Dark, reader: :private

  def view_template
    div(class: "rounded-md border px-4 py-3 text-sm font-medium mb-3 #{bg_variant.alert_class}") do
      span(class: text_variant.text_class) { label }
    end
  end
end
