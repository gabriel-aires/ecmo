require "uuid"

abstract class Application < ActionController::Base

  force_ssl
  layout "layout.slang"
  Log = ::App::Log.for("controller")
  before_action :set_request_id
  before_action :set_date_header
  before_action :require_login
  before_action :require_read, only: [:index, :show]
  before_action :require_write, except: [:index, :show]

  include SessionUtils

  def set_request_id
    request_id = UUID.random.to_s
    Log.context.set client_ip: client_ip, request_id: request_id
    response.headers["X-Request-ID"] = request_id
  end

  def set_date_header
    response.headers["Date"] = HTTP.format_time(Time.utc)
  end

  def require_read
    true
  end

  def require_write
    false
  end

end
