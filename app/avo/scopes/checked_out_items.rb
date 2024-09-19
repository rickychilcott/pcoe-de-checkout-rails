class Avo::Scopes::CheckedOutItems < Avo::Advanced::Scopes::BaseScope
  self.name = "Checked Out"
  # self.description = "Checked out items description."
  self.scope = -> { query.checked_out }
  self.visible = -> { true }
end
