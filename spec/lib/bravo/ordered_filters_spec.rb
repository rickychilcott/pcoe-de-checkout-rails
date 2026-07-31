require "rails_helper"

RSpec.describe "Bravo filter ordering" do
  # Panel order must track index column order: left-to-right on the index reads
  # top-to-bottom in the filters panel. Unanchored filters (derived, no column) come first.
  def labels_for(resource_class)
    resource = resource_class.new(view: :index, context: ApplicationController.helpers)

    resource.ordered_filters.map do |filter|
      filter.is_a?(Bravo::Field) ? filter.filterable[:label] : filter.title
    end
  end

  it "orders Checkout filters to match its columns" do
    expect(labels_for(Bravo::Resources::Checkout))
      .to eq ["Checkout status", "Item Name", "Group", "Location", "Customer Name", "Checked out between"]
  end

  it "orders Item filters to match its columns" do
    expect(labels_for(Bravo::Resources::Item))
      .to eq ["Name", "Location", "Group", "Item status", "Parent Item", "QR Code Identifier"]
  end

  it "orders Customer filters to match its columns" do
    expect(labels_for(Bravo::Resources::Customer))
      .to eq ["Name", "Role", "Ohio ID", "Email", "PID", "Checked out item count", "Past due item count"]
  end
end
