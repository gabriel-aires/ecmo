require "uuid"

abstract class Application < ActionController::Base

  @title : String?
  @description : String?
  @alert : String?

  force_ssl
  layout "layout.cr"
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
    @alert = "Read access required"
    authorize_groups App::ALLOW_WRITE + " " + App::ALLOW_READ
  end

  def require_write
    @alert = "Write access required"
    authorize_groups App::ALLOW_WRITE
  end

  def authorize_groups(group_names : String)
    user  = current_user.not_nil!
    route = self.class.name + "#" + action_name.to_s
    level = @alert.to_s
    granted = group_names.strip
    time  = Time.utc
    perm = "#{level} for #{route} | Groups allowed: #{granted}."

    if (user.groups & granted.split(" ")).empty?
      
      notice "Access denied for user '#{user.name}'"
      puts "#{time} | #{user.name} blocked. | #{perm}"

      respond_with do
        html template("unauthorized.cr")
      end

    else
      puts "#{time} | #{user.name} granted. | #{perm}"

    end

  end

end
