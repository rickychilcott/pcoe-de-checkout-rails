# frozen_string_literal: true

class ApplicationComponent < Phlex::HTML
  include ActionView::RecordIdentifier
  include Phlex::Helpers
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Pluralize
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TimeAgoInWords
  include Phlex::Rails::Helpers::TurboFrameTag

  extend Literal::Properties

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end
end
