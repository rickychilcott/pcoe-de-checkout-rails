class Avo::Resources::AdminUser < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :email, as: :text

    field :password, as: :password, disabled: true, required: false

    field :sign_in_count, as: :number, disabled: true
    field :current_sign_in_at, as: :date_time, disabled: true
    field :last_sign_in_at, as: :date_time, disabled: true
    field :current_sign_in_ip, as: :text, disabled: true
    field :last_sign_in_ip, as: :text, disabled: true

    field :groups, as: :has_many
  end
end
