class Bravo::SelectFilter
  class << self
    attr_accessor :title

    def key = name.demodulize.underscore
  end

  # Subclasses override: apply(request, query, value) -> scope, options -> hash
  def apply(_request, query, _value) = query

  def options = {}

  def default = nil
end
