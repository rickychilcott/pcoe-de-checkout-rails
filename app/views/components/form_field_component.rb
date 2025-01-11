class FormFieldComponent < ApplicationComponent
  prop :form, ActionView::Helpers::FormBuilder, reader: :private
  prop :field, Symbol, reader: :private
  prop :name, _Nilable(String), reader: :private do |value|
    value || field.to_s.humanize
  end

  def view_template(&)
    render_label
    yield_content(&)
    render_errors if has_errors?
  end

  private

  def render_label
    raw form.label(field, name, class: "form-label")
  end

  def render_errors
    div(class: "invalid-feedback") do
      plain form.object.errors[field].join(", ")
    end
  end

  def has_errors?
    form.object.errors[field].any?
  end
end
