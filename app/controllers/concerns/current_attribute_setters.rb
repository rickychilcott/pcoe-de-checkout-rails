module CurrentAttributeSetters
  extend ActiveSupport::Concern

  included do
    before_action :set_current_admin_user, if: :admin_user_signed_in?
    before_action :set_current_request_info
    before_action :set_error_context
  end

  private

  def set_current_admin_user
    Current.admin_user = current_admin_user
  end

  # Recorded against every Solid Errors occurrence, so a reported exception
  # names the admin who hit it.
  def set_error_context
    Rails.error.set_context(
      admin_user_id: current_admin_user&.id,
      admin_user_email: current_admin_user&.email,
      request_id: request.uuid,
      request_url: request.original_url
    )
  end

  def set_current_request_info
    Current.request_id = request.uuid
    Current.user_agent = request.user_agent
    Current.ip_address = request.remote_ip
  end
end
