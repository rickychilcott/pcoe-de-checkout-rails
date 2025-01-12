# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index? = super_admin?

  def show? = super_admin?

  def create? = super_admin?

  def new? = create?

  def update? = super_admin?

  def edit? = update?

  def destroy? = super_admin?

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope

    def all_or_in_group
      raise ArgumentError, "#{record.class} does not implement #group" unless scope_record.respond_to?(:group)

      if user.super_admin?
        scope.all
      else
        scope.where(group: user.groups)
      end
    end

    def scope_record
      scope.new
    end
  end

  private

  delegate :super_admin?, to: :user

  def in_group?
    raise ArgumentError, "#{record.class} does not implement #group" unless record.respond_to?(:group)

    record.group.in?(user.groups)
  end
end
