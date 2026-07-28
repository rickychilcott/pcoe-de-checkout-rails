class Bravo::SelectFilter
  class << self
    attr_accessor :title

    def key = name.demodulize.underscore
  end

  # Subclasses override: apply(query, value) -> scope, options -> hash
  def apply(query, _value) = query

  def options = {}

  def default = nil
end
