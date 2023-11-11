# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby "~> 3.2"

gem "faraday"
gem "telegram-bot-ruby", require: "telegram/bot"
gem "puma"
gem "sinatra", require: "sinatra/base", github: "dentarg/sinatra", branch: "rack-3"
gem "rake"
gem "pry-byebug"
gem "sequel"
gem "pg"
gem "config"
gem "zeitwerk"

group :development do
  gem "standardrb"
end

group :test do
  gem "timecop"
  gem "rspec"
  gem "simplecov"
  gem "database_cleaner-sequel"
end
