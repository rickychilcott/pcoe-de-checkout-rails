class Avo::Scopes::CurrentCheckouts < Avo::Advanced::Scopes::BaseScope
  self.name = "Current"
  self.description = "This shows all checkouts including those that are past due."
  self.scope = -> { query.checked_out }
  self.visible = -> { true }
end
