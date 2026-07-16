class CardComponent < ApplicationComponent
  prop :id, String, reader: :private
  prop :title, String, reader: :private

  def view_template(&block)
    div(class: "rounded-lg bg-white border border-gray-200 shadow-sm", id:) do
      div(class: "p-4") do
        h2(class: "text-lg font-bold mb-3") { title }
        div(&block) if block
      end
    end
  end
end
