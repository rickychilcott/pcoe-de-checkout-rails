class Bravo::Field
  VIEWS = [:index, :show, :new, :edit].freeze
  FORM_VIEWS = [:new, :edit].freeze

  # Per-type views hidden unless explicitly re-enabled with show_on/only_on
  DEFAULT_HIDDEN = {
    badge: [:new, :edit],
    password: [:index, :show],
    trix: [:index],
    key_value: [:index],
    files: [:index],
    external_image: [:new, :edit],
    has_many: [:index, :new, :edit],
    checkboxes: [:index, :show]
  }.freeze

  attr_reader :id, :type, :options, :block

  def initialize(id, as: :text, **options, &block)
    @id = id
    @type = as
    @options = options
    @block = block
  end

  def label = options[:name] || id.to_s.humanize(keep_id_suffix: true)

  def readonly? = !!options[:readonly] || type == :has_many

  def required? = !!options[:required]

  def sortable? = !!options[:sortable]

  def copyable? = !!options[:copyable]

  def link_to_record? = !!options[:link_to_record]

  def placeholder = options[:placeholder]

  def description = options[:description]

  def filterable = options[:filterable]

  def use_resource = options[:use_resource]

  # data attributes for the form input (ported from Avo's html: option)
  def input_data = options.dig(:html, :edit, :input, :data) || {}

  def visible_on?(view, context)
    views = VIEWS - Array(DEFAULT_HIDDEN[type])
    views -= FORM_VIEWS if readonly?
    views |= Array(options[:show_on])
    views -= Array(options[:hide_on])
    views = Array(options[:only_on]) if options[:only_on]
    return false unless view.in?(views)

    visible = options[:visible]
    return true if visible.nil?

    args = (visible.arity == 0) ? [] : [view]
    !!context.instance_exec(*args, &visible)
  end

  # Key(s) for strong params on forms
  def param_key
    case type
    when :belongs_to then :"#{id}_id"
    when :files, :checkboxes then {id => []}
    else id
    end
  end

  def value_for(record, view_context)
    if block
      Evaluator.new(record:, view_context:).evaluate(&block)
    else
      record.public_send(id)
    end
  end

  def formatted_value(record, view_context)
    value = value_for(record, view_context)
    return value unless options[:format_using]

    Evaluator.new(record:, view_context:, value:).evaluate(&options[:format_using])
  end

  def select_options(view_context)
    opts = options[:options]
    opts.respond_to?(:call) ? view_context.instance_exec(&opts) : opts
  end

  def include_blank? = !!options[:include_blank]

  def default_value
    d = options[:default]
    d.respond_to?(:call) ? d.call : d
  end

  # Evaluates field blocks (computed values, format_using) with access to the
  # record, the formatted value, and all view helpers.
  class Evaluator
    attr_reader :record, :value

    def initialize(record:, view_context:, value: nil)
      @record = record
      @view_context = view_context
      @value = value
    end

    def evaluate(&block) = instance_exec(&block)

    def method_missing(name, ...) = @view_context.send(name, ...)

    def respond_to_missing?(name, include_private = false)
      @view_context.respond_to?(name, include_private)
    end
  end
end
