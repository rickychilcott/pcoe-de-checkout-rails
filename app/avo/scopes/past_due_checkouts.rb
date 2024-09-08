class Avo::Scopes::PastDueCheckouts < Avo::Advanced::Scopes::BaseScope
  self.name = "Past Due"
  self.description = "This shows only past due checkouts."
  self.scope = -> { query.past_due }
  # self.visible = -> { true }
end
