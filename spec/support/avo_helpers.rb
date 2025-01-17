module AvoHelpers
  def open_resource_filters
    find("button[data-button='resource-filters']").click
  end

  def select_filter_option(filter_name, value)
    find("[data-filter-name='#{filter_name}'] option[value='#{value}']").select_option
  end

  def expect_applied_filters_count(count)
    expect(page).to have_content "Filters\n(#{count} applied)"
  end
end

RSpec.configure do |config|
  config.include AvoHelpers, type: :system
end
