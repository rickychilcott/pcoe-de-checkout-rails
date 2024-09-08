# == Schema Information
#
# Table name: checkouts
#
#  id                 :integer          not null, primary key
#  checked_out_at     :datetime
#  expected_return_on :date
#  returned_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  checked_out_by_id  :integer          not null
#  customer_id        :integer          not null
#  item_id            :integer          not null
#  returned_by_id     :integer
#
# Indexes
#
#  index_checkouts_on_checked_out_by_id  (checked_out_by_id)
#  index_checkouts_on_customer_id        (customer_id)
#  index_checkouts_on_item_id            (item_id)
#  index_checkouts_on_returned_by_id     (returned_by_id)
#
# Foreign Keys
#
#  checked_out_by_id  (checked_out_by_id => admin_users.id)
#  customer_id        (customer_id => customers.id)
#  item_id            (item_id => items.id)
#  returned_by_id     (returned_by_id => admin_users.id)
#
class Avo::Resources::Checkout < Avo::BaseResource
  self.includes = [:customer, :item]
  # self.attachments = []
  self.search = {
    query: -> do
      query
        .ransack(
          customer_name_cont: params[:q],
          item_name_cont: params[:q],
          m: "or"
        )
        .result(distinct: false)
    end,
    item: -> do
            {
              title: "#{record.customer.name} checked out #{record.item.name}",
              description: "Expected Return: #{record.expected_return_on_text}"
              # image_url: main_app.url_for(record.cover_photo),
              # image_format: :rounded
            }
          end
  }

  def fields
    field :item, as: :belongs_to, readonly: true
    field :customer, as: :belongs_to, readonly: true

    field :checked_out_at, name: "Checked Out", as: :date_time, readonly: true, format: "yyyy-LL-dd h:mm a"
    field :checked_out_by, as: :belongs_to, readonly: true

    field :expected_return_on_text, name: "Expected Return", as: :text, readonly: true, format_using: -> do
      color =
        if record.past_due?
          "red"
        elsif record.due_soon?
          "amber"
        else
          "green"
        end

      tag.span class: "text-#{color}-600" do
        value
      end
    end

    field :returned_at, as: :date_time, readonly: true
    field :returned_by, as: :belongs_to, readonly: true
  end

  def scopes
    scope Avo::Scopes::CurrentCheckouts, default: true
    scope Avo::Scopes::PastDueCheckouts
    scope Avo::Scopes::CompletedCheckouts
  end
end
