class Bravo::BaseResource
  class << self
    # self.search = {query: -> { ... }, help: "..."}
    attr_accessor :search

    # self.includes = [:assoc, ...] for index eager loading
    attr_writer :includes

    def includes = @includes || []

    def model_class = @model_class ||= name.demodulize.constantize

    def route_key = model_class.model_name.route_key

    def label
      plural = model_class.model_name.human(count: 2)
      # i18n falls back to the singular when no plural entry exists
      (plural == label_singular) ? plural.pluralize : plural
    end

    def label_singular = model_class.model_name.human
  end

  attr_reader :view, :record, :context

  # view: :index | :show | :new | :edit
  # context: object answering view-helper calls (view_context or controller)
  def initialize(view:, context:, record: nil)
    @view = view
    @context = context
    @record = record
  end

  # Subclasses override with field/action/filter DSL calls
  def fields
  end

  def actions
  end

  def filters
  end

  # Hook for resources to massage permitted params before save (e.g. drop
  # blank passwords). Returns the attributes hash to assign.
  def prepare_params(attrs) = attrs

  def field(id, **options, &block)
    @collected_fields << Bravo::Field.new(id, **options, &block)
  end

  def action(klass)
    @collected_actions << klass
  end

  def filter(klass)
    @collected_filters << klass
  end

  def all_fields
    @all_fields ||= collect(:fields)
  end

  def all_actions
    @all_actions ||= collect(:actions)
  end

  def all_filters
    @all_filters ||= collect(:filters)
  end

  def visible_fields
    all_fields.select { |f| f.visible_on?(view, context) }
  end

  def has_many_fields
    visible_fields.select { |f| f.type == :has_many }
  end

  def panel_fields
    visible_fields - has_many_fields
  end

  # Field-level filters (filterable: {label:, query_attributes:}) shown in the
  # filters panel alongside the resource's select filters.
  def filterable_fields
    all_fields.select(&:filterable)
  end

  def permitted_params
    visible_fields.reject(&:readonly?).map(&:param_key)
  end

  private

  def collect(kind)
    @collected_fields = []
    @collected_actions = []
    @collected_filters = []
    public_send(kind)
    instance_variable_get(:"@collected_#{kind}")
  end
end
