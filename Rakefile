require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "app"
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task default: :test

task :update_games do
  require_relative "./config/boot"

  epic_url = "https://store-site-backend-static.ak.epicgames.com".freeze

  adapter = EpicAdapter.new(epic_url)
  UpdateGames.new(adapter).call
end

task :notify_new_promotions do
  require_relative "./config/boot"

  NotifyTelegram.new.call
end

namespace :db do
  task :create, [:db_name] do |t, args|
    require "sequel"

    db = Sequel.connect(ENV["POSTGRES_URL"].to_s)
    db.run("DROP DATABASE IF EXISTS #{args[:db_name]}")
    db.run("CREATE DATABASE #{args[:db_name]}")
  end

  task :migrate do
    require "sequel"
    require "sequel/extensions/migration"

    Sequel::Migrator.run(Sequel.connect(ENV["DATABASE_URL"].to_s), "db/migrations")
  end

  namespace :test do
    task :migrate do
      require "sequel"
      require "sequel/extensions/migration"

      test_database = ENV["DATABASE_TEST_URL"]
      db = Sequel.connect(ENV["POSTGRES_URL"].to_s)
      db.run("DROP DATABASE IF EXISTS \"#{test_database}\"")
      db.run("CREATE DATABASE \"#{test_database}\"")

      Sequel::Migrator.run(Sequel.connect(test_database), "db/migrations")
    end
  end

  namespace :seed do
    task :past_promotions do
      require_relative "./config/boot"

      require_relative "./db/load_past_promotions"

      api_url = "https://store.epicgames.com/graphql"

      LoadPastPromotions.new("./db/past_promotions.txt", api_url).call
    end
  end
end
