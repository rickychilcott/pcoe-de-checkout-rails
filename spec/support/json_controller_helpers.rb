module JsonControllerHelpers
  def parsed_results = parsed_body.fetch("results")

  def parsed_body = JSON.parse(response.body)
end

RSpec.configure do |config|
  config.include JsonControllerHelpers, type: :controller
end
