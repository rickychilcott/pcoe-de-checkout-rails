module CurrentAttributeSetters
  extend ActiveSupport::Concern

  included do
    before_action :set_current_admin_user, if: :admin_user_signed_in?
    before_action :set_current_request_info
  end

  private

  def set_current_admin_user
    Current.admin_user = current_admin_user
  end

  def set_current_request_info
    Current.request_id = request.uuid
    Current.user_agent = request.user_agent
    Current.ip_address = request.remote_ip
  end
end
