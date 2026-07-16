module Wcag2Compliance
  def be_wcag2_accessible
    be_axe_clean
      .according_to(:wcag2a, :wcag2aa)
      .skipping("duplicate-id", "color-contrast", "aria-required-children", "select-name", "aria-allowed-attr")
  end
end

RSpec.configure do |config|
  config.include Wcag2Compliance, type: :system
end
