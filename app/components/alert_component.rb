class AlertComponent < ApplicationComponent
  prop :label, String, reader: :private
  prop :bg_variant, BsVariant, default: BsVariant::Secondary, reader: :private
  prop :text_variant, BsVariant, default: BsVariant::Dark, reader: :private

  def view_template
    div(class: "alert #{bg_variant.alert_class}") do
      span(class: text_variant.text_class) { label }
    end
  end
end
