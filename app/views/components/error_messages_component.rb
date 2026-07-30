class ErrorMessagesComponent < ApplicationComponent
  prop :resource, _Any, reader: :private

  def render? = resource.errors.any?

  def view_template
    div(class: "rounded-md bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-800 mb-4") do
      h4(class: "font-semibold mb-1") do
        plain "#{pluralize(resource.errors.count, "error")} prohibited this #{resource.class.name.downcase} from being saved:"
      end
      ul(class: "list-disc pl-5") do
        resource.errors.full_messages.each do |msg|
          li { plain msg }
        end
      end
    end
  end
end
