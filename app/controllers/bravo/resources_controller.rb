class Bravo::ResourcesController < Bravo::BaseController
  PER_PAGE = 24

  before_action :set_resource_class
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  def index
    authorize model_class, :index?

    scope = resolved_policy_scope(model_class)
    scope = scope.includes(*resource_class.includes) if resource_class.includes.any?
    scope = apply_search(scope)
    scope = apply_filters(scope)
    scope = apply_sort(scope)

    @resource = build_resource(:index)
    @pagy, @records = pagy(scope, limit: PER_PAGE)
  end

  def show
    authorize @record, :show?
    @resource = build_resource(:show, record: @record)
  end

  def new
    authorize model_class, :create?
    @record = model_class.new
    @resource = build_resource(:new, record: @record)
  end

  def create
    authorize model_class, :create?
    @record = model_class.new
    @resource = build_resource(:new, record: @record)
    @record.assign_attributes(@resource.prepare_params(permitted_attributes))

    if @record.save
      redirect_to bravo_resource_path(params[:resource_name], @record), notice: "#{resource_class.label_singular} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @record, :update?
    @resource = build_resource(:edit, record: @record)
  end

  def update
    authorize @record, :update?
    @resource = build_resource(:edit, record: @record)

    if @record.update(@resource.prepare_params(permitted_attributes))
      redirect_to bravo_resource_path(params[:resource_name], @record), notice: "#{resource_class.label_singular} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @record, :destroy?
    @record.destroy!
    redirect_to bravo_resources_path(params[:resource_name]), notice: "#{resource_class.label_singular} was successfully destroyed."
  end

  private

  attr_reader :resource_class

  delegate :model_class, to: :resource_class

  helper_method :resource_class, :model_class

  def set_resource_class
    @resource_class = Bravo.resource_for(params[:resource_name]) or raise ActiveRecord::RecordNotFound
  end

  def set_record
    @record = model_class.find(params[:id])
  end

  def build_resource(view, record: nil)
    resource_class.new(view:, context: view_context, record:)
  end

  def permitted_attributes
    params.require(model_class.model_name.param_key).permit(*@resource.permitted_params)
  end

  def apply_search(scope)
    q = params[:q].to_s.strip
    return scope if q.blank? || resource_class.search.nil?

    Bravo::SearchContext.new(scope, q).instance_exec(&resource_class.search[:query])
  end

  def apply_filters(scope)
    resource = build_resource(:index)

    resource.all_filters.each do |filter_class|
      filter = filter_class.new
      value = params.dig(:filters, filter_class.key).presence || filter.default
      scope = filter.apply(request, scope, value)
    end

    resource.filterable_fields.each do |field|
      value = params.dig(:filters, field.id).presence
      next if value.blank?

      conditions = field.filterable[:query_attributes].index_by { |attr| "#{attr}_cont" }.transform_values { value }
      scope = scope.ransack(conditions.merge(m: "or")).result
    end

    scope
  end

  def apply_sort(scope)
    field = build_resource(:index).all_fields.find { |f| f.sortable? && f.id.to_s == params[:sort] }
    return scope.order(id: :desc) unless field

    direction = (params[:dir] == "desc") ? :desc : :asc

    if field.type == :belongs_to
      reflection = model_class.reflect_on_association(field.id)
      scope.left_joins(field.id).order(reflection.klass.arel_table[:name].public_send(direction))
    elsif model_class.column_names.include?(field.id.to_s)
      scope.order(field.id => direction)
    else
      scope
    end
  end
end
