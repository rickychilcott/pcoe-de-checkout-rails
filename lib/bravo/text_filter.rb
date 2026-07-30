class Bravo::TextFilter
  class << self
    attr_accessor :title

    def key = name.demodulize.underscore
  end

  # Subclasses override: apply(query, value) -> scope
  def apply(query, _value) = query
end
