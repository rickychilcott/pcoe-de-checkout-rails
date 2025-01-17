class ApplicationInteraction < ActiveInteraction::Base
  include ActiveInteraction::Extras::ActiveJob
  include ActiveInteraction::Extras::Transaction
  include ActivityLoggable

  class Job < ActiveJob::Base
    include ActiveInteraction::Extras::ActiveJob::Perform
  end

  def errors? = errors.any?
end
