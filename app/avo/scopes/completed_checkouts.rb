class Avo::Scopes::CompletedCheckouts < Avo::Advanced::Scopes::BaseScope
  self.name = "Completed"
  self.description = "This shows all checkouts including those that are past due."
  self.scope = -> { query.checked_in }
  self.visible = -> { true }
end
