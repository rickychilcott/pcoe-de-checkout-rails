class Bravo::Filters::CheckoutCustomerFilter < Bravo::SelectFilter
  self.title = "Customer Name"

  def apply(query, value)
    value.present? ? query.where(customer_id: value) : query
  end

  def options
    {"" => "All"}.merge(Customer.order(:name).pluck(:id, :name).to_h)
  end
end
