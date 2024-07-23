class Current < ActiveSupport::CurrentAttributes
  attribute :admin_user
  attribute :request_id, :user_agent, :ip_address
end
