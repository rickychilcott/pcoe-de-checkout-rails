class Bravo::Filters::CustomerRoleFilter < Bravo::SelectFilter
  self.title = "Role"

  def apply(query, value)
    value.present? ? query.where(role: value) : query
  end

  def options
    {"" => "All"}.merge(Customer::ROLE_LABELS)
  end
end
