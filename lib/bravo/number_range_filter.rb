class Bravo::NumberRangeFilter
  class << self
    attr_accessor :title

    def key = name.demodulize.underscore
  end

  # Subclasses override: apply(query, min, max) -> scope
  def apply(query, _min, _max) = query
end
