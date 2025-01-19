# frozen_string_literal: true

class ListComponent < ApplicationComponent
  prop :items, _Enumerable(_Any), reader: :private
  prop :fallback, String, reader: :private

  def view_template
    ul(class: "list-group") do
      if items.any?
        items.each do |item|
          list_item do
            yield(item)
          end
        end
      else
        list_item do
          fallback
        end
      end
    end
  end

  private

  def list_item
    li(class: "list-group-item") do
      yield
    end
  end
end
