class ApplicationInteraction < ActiveInteraction::Base
  include ActiveInteraction::Extras::ActiveJob
  include ActiveInteraction::Extras::Transaction

  class Job < ActiveJob::Base
    include ActiveInteraction::Extras::ActiveJob::Perform
  end
end
