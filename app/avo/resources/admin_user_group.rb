class Avo::Resources::AdminUserGroup < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id

    field :admin_user, as: :belongs_to
    field :group, as: :belongs_to
  end
end
