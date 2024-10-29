# frozen_string_literal: true

class ListComponent < ApplicationComponent
  prop :items, _Enumerable(_Any), reader: :private

  def view_template
    ul(class: "list-group") do
      items.each do |item|
        li(class: "list-group-item") do
          yield(item)
        end
      end
    end
  end
end
