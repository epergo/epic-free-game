# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby "~> 3.4"

gem "config"
gem "faraday"
gem "pg"
gem "pry-byebug"
gem "puma"
gem "rackup"
gem "rake"
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
