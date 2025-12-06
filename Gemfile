# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby "~> 4"

gem "config"
gem "faraday"
gem "pg"
gem "irb"
gem "puma"
gem "rackup"
gem "rake"
gem "rufus-scheduler"
gem "sequel"
gem "sinatra", require: "sinatra/base"
gem "telegram-bot-ruby", require: "telegram/bot"
gem "zeitwerk"

group :development do
  gem "standardrb"
  gem "ruby-lsp"
end

group :test do
  gem "database_cleaner-sequel"
  gem "rspec"
  gem "simplecov"
  gem "timecop"
end
