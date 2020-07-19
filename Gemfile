source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.1"

gem "active_model_serializers"
gem "bootsnap", ">= 1.4.2", require: false
gem "config"
gem "dotenv-rails"
gem "mysql2"
gem "pagy"
gem "rack-cors"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.2", ">= 6.0.2.2"

group :development, :test do
  gem "brakeman", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-rails"
  gem "rails_best_practices"
  gem "reek"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "shoulda-matchers"
  gem "simplecov"
  gem "simplecov-json"
  gem "simplecov-rcov"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
