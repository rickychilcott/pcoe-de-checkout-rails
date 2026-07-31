class Bravo::Resources::Checkout < Bravo::BaseResource
  self.includes = [:customer, :checked_out_by, :returned_by, item: [:group, :location]]
  self.csv_export = true

  self.search = {
    query: -> do
      query
        .ransack(
          customer_name_cont: q,
          item_name_cont: q,
          m: "or"
        )
        .result(distinct: false)
    end
  }

  def fields
    field :title, as: :text, link_to_record: true
    field :item, as: :belongs_to, readonly: true, filterable: {
      label: "Item Name",
      query_attributes: [:item_name]
    }
    field :group, as: :belongs_to, readonly: true
    field :location, as: :belongs_to, readonly: true
    field :customer, as: :belongs_to, readonly: true, filterable: {
      label: "Customer Name",
      query_attributes: [:customer_name]
    }

    field :checked_out_at, name: "Checked Out", as: :date_time, readonly: true
    field :checked_out_by, as: :belongs_to, readonly: true

    field :expected_return_on_text, name: "Expected Return", as: :text, readonly: true, format_using: -> do
      css =
        if record.past_due?
          "text-red-600"
        elsif record.due_soon?
          "text-amber-600"
        else
          "text-green-600"
        end

      tag.span(value, class: css)
    end

    field :returned_at, as: :date_time, readonly: true
    field :returned_by, as: :belongs_to, readonly: true
  end

  def filters
    filter Bravo::Filters::CheckoutStatusFilter
    filter Bravo::Filters::CheckoutGroupFilter, field: :group
    filter Bravo::Filters::CheckoutLocationFilter, field: :location
    filter Bravo::Filters::CheckedOutDateRangeFilter, field: :checked_out_at
  end
end
