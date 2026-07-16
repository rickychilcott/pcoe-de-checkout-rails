# Bravo is this app's homegrown replacement for Avo: resource classes declare
# fields/actions/filters with an Avo-like DSL, and a single generic controller
# + ERB renderers provide the admin UI under /admin.
module Bravo
  def self.resource_for(resource_name)
    "Bravo::Resources::#{resource_name.to_s.classify}".safe_constantize
  end

  def self.resource_for_model(model_class)
    resource_for(model_class.model_name.plural)
  end
end
