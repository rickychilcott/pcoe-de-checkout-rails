ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Rails 8 freezes ActiveSupport::Dependencies.autoload_paths during boot.
# The avo gem's engine initializer calls .delete() on this array, which
# raises FrozenError in some environments (CI) due to initializer ordering.
require "active_support/dependencies"
original = ActiveSupport::Dependencies.autoload_paths
resilient = Class.new(Array) {
  def unshift(*args) = frozen? ? self : super
  def delete(obj) = frozen? ? nil : super
}.new(original)
ActiveSupport::Dependencies.autoload_paths = resilient
