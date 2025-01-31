# frozen_string_literal: true

class ListComponent < ApplicationComponent
  prop :id, _String?, reader: :private
  prop :items, _Enumerable(_Any), reader: :private
  prop :fallback, String, reader: :private

  def view_template
    ul(id:, class: "list-group ms-2 pe-3") do
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
