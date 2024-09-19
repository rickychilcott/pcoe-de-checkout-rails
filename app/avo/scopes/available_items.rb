class Avo::Scopes::AvailableItems < Avo::Advanced::Scopes::BaseScope
  self.name = "Available"
  # self.description = "Available items description."
  self.scope = -> { query.not_checked_out }
  self.visible = -> { true }
end
