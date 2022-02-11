require "action-controller/logger"

module App
  NAME    = "Ecmo"
  DESC    = "Easy Configuration Management Orchestration"
  ROOT    = "/opt/ecmo"
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}

  Log         = ::Log.for(NAME)

  LOG_BACKEND = begin
    ActionController.default_backend io: File.new(ROOT + "/access.log", "a")
  rescue
    ActionController.default_backend
  end

  ENVIRONMENT = ENV["MODE"]? || "development"

  DEFAULT_PORT          = (ENV["SERVER_PORT"]? || 3000).to_i
  DEFAULT_HOST          = ENV["SERVER_HOST"]? || "127.0.0.1"
  DEFAULT_PROCESS_COUNT = 1 # avoid race conditions with sqlite embedded database

  SSL_PKEY = ENV["SSL_PKEY"]? || ROOT + "/localhost.key"
  SSL_CERT = ENV["SSL_CERT"]? || ROOT + "/localhost.crt"

  DB_RETENTION  = (ENV["DB_RETENTION"]? || 7).to_i

  ALLOW_READ    = ENV["ALLOW_READ"]? || ""
  ALLOW_WRITE   = ENV["ALLOW_WRITE"]? || "wheel"

  COOKIE_SESSION_KEY    = ENV["SESSION_KEY"]? || "_ecmo_"
  COOKIE_SESSION_SECRET = ENV["SESSION_SECRET"]? || "4f74c0b358d5bab4000dd3c75465dc2c"

  def self.running_in_production?
    ENVIRONMENT == "production"
  end
end
