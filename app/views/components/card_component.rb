class CardComponent < ApplicationComponent
  prop :id, String, reader: :private
  prop :title, String, reader: :private

  def view_template(&block)
    div(class: "card", id:) do
      div(class: "card-body") do
        h2(class: "card-title") { title }
        div(&block) if block
      end
    end
  end
end
