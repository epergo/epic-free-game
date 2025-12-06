require "bundler/setup"

ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"])

Config.load_and_set_settings(Config.setting_files("config", ENV["RACK_ENV"]))

require "net/http"
require "time"
require "json"
require "logger"

loggers = (Settings.environment == "development") ? Logger.new($stdout) : []

database_url = "postgres://#{ENV["POSTGRES_USER"]}:#{ENV["POSTGRES_PASSWORD"]}@#{ENV["POSTGRES_HOST"]}:5432/#{ENV["POSTGRES_DB"]}"
Sequel.connect(database_url.to_s, loggers:)
Sequel::Model.plugin(:update_or_create)

loader = Zeitwerk::Loader.new
loader.push_dir("app/models")
loader.push_dir("app")
loader.push_dir("web")
loader.setup
loader.eager_load
