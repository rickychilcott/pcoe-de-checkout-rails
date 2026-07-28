class Bravo::ResourceActionsController < Bravo::BaseController
  def create
    resource_class = Bravo.resource_for(params[:resource_name]) or raise ActiveRecord::RecordNotFound
    authorize resource_class.model_class, :act_on?

    resource = resource_class.new(view: :index, context: view_context)
    action_class = resource.all_actions.find { |a| a.key == params[:action_key] } or raise ActiveRecord::RecordNotFound

    action = action_class.new
    action.handle(fields: params[:fields] || {}, current_user: current_admin_user)

    if action.error_message
      redirect_to bravo_resources_path(params[:resource_name]), alert: action.error_message
    else
      redirect_to bravo_resources_path(params[:resource_name]), notice: action.success_message
    end
  end
end
