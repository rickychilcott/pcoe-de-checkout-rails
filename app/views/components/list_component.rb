# frozen_string_literal: true

class ListComponent < ApplicationComponent
  prop :id, _String?, reader: :private
  prop :items, _Enumerable(_Any), reader: :private
  prop :fallback, String, reader: :private

  def view_template
    ul(id:, class: "hide-first-if-multiple rounded-md border border-gray-200 divide-y divide-gray-100 bg-white") do
      # will be hidden via CSS if there are multiple items
      list_item do
        fallback
      end

      items.each do |item|
        list_item do
          yield(item)
        end
      end
    end
  end

  private

  def list_item
    li(class: "px-3 py-2 text-sm hover:bg-stone-50 transition-colors") do
      yield
    end
  end
end
