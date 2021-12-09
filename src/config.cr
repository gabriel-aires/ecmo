# Application dependencies
require "action-controller"
require "kilt/slang"
require "hardware"
require "psutil"
require "granite"
require "granite/adapter/sqlite"
require "./constants"

# Connect to database
Granite::Connections << Granite::Adapter::Sqlite.new(name: "embedded", url: "sqlite3://#{App::ROOT}/data.db")

# Application code
require "./models/*"
require "./controllers/application"
require "./controllers/*"

# Start jobs
require "./tasks/schedule"
require "./tasks/*"

# Server required after application controllers
require "action-controller/server"

# Configure logging (backend defined in constants.cr)
if App.running_in_production?
  log_level = Log::Severity::Info
  ::Log.setup "*", :warn, App::LOG_BACKEND
else
  log_level = Log::Severity::Debug
  ::Log.setup "*", :info, App::LOG_BACKEND
end
Log.builder.bind "action-controller.*", log_level, App::LOG_BACKEND
Log.builder.bind "#{App::NAME}.*", log_level, App::LOG_BACKEND

# Filter out sensitive params that shouldn't be logged
filter_params = ["password", "bearer_token"]
keeps_headers = ["X-Request-ID"]

# Add handlers that should run before your application
ActionController::Server.before(
  ActionController::ErrorHandler.new(App.running_in_production?, keeps_headers),
  ActionController::LogHandler.new(filter_params),
  HTTP::CompressHandler.new
)

# Static file serving disabled, files are stored in embedded vfs
#
# Optional support for serving of static assests
# if File.directory?(App::STATIC_FILE_PATH)
#   # Optionally add additional mime types
#   ::MIME.register(".yaml", "text/yaml")

#   # Check for files if no paths matched in your application
#   ActionController::Server.before(
#     ::HTTP::StaticFileHandler.new(App::STATIC_FILE_PATH, directory_listing: false)
#   )
# end

# Configure session cookies
# NOTE:: Change these from defaults
ActionController::Session.configure do |settings|
  settings.key = App::COOKIE_SESSION_KEY
  settings.secret = App::COOKIE_SESSION_SECRET
  # HTTPS only:
  settings.secure = App.running_in_production?
end
