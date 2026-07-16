module BravoHelpers
  def open_resource_actions
    find("summary", text: "Actions").click
  end

  def open_resource_filters
    find("summary", text: "Filters").click
  end

  def select_filter_option(filter_name, value)
    find("select[data-filter-name='#{filter_name}'] option[value='#{value}']").select_option
    click_on "Apply"
  end

  def expect_applied_filters_count(count)
    expect(page).to have_content "Filters (#{count} applied)"
  end
end

RSpec.configure do |config|
  config.include BravoHelpers, type: :system
end
