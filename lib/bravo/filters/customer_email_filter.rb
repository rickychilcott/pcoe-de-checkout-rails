class Bravo::Filters::CustomerEmailFilter < Bravo::TextFilter
  self.title = "Email"

  def apply(query, value)
    return query if value.blank?

    query.where("(ohio_id || '@ohio.edu') LIKE ?", "%#{value}%")
  end
end
