class Bravo::DateRangeFilter
  class << self
    attr_accessor :title

    def key = name.demodulize.underscore
  end

  # Subclasses override: apply(query, from, to) -> scope
  def apply(query, _from, _to) = query

  def default_from = nil

  def default_to = nil
end
