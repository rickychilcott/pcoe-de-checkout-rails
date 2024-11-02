class ErrorMessagesComponent < ApplicationComponent
  prop :resource, _Any, reader: :private

  def render? = resource.errors.any?

  def view_template
    div(class: "alert alert-danger") do
      h4 do
        plain "#{pluralize(resource.errors.count, "error")} prohibited this #{resource.class.name.downcase} from being saved:"
      end
      ul do
        resource.errors.full_messages.each do |msg|
          li { plain msg }
        end
      end
    end
  end
end
