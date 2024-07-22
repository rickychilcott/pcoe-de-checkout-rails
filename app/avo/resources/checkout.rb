class Avo::Resources::Checkout < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :checked_out_at, as: :datetime, readonly: true
    field :checked_out_admin_user, as: :belongs_to, readonly: true

    field :returned_at, as: :datetime, readonly: true
    field :returned_admin_user, as: :belongs_to, readonly: true

    field :expected_return_on, as: :date, readonly: true
    field :customer, as: :belongs_to, readonly: true
    field :item, as: :belongs_to, readonly: true
  end
end
