source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.3"

# = Core =
gem "rails", "~> 8.0.0"
gem "puma"
gem "bootsnap", require: false
gem "good_job", "~> 3.14"
gem "dalli"
gem "redis"
gem "csv"

# = Database =
gem "pg", "~> 1.1"
gem "pg_search", "~> 2.3"
gem "hashid-rails", "~> 1.4"

# = Frontend =
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails", "~> 1.0"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "local_time", "~> 2.1"
gem "inline_svg", "~> 1.8"
gem "imagekitio"
gem "attributes_and_token_lists", github: "seanpdoyle/attributes_and_token_lists", branch: "main"
gem "rails_autolink", "~> 1.1"

# = Authentication =
gem "bcrypt", "~> 3.1.7"

# = Utilities =
gem "feedjira", "~> 3.2"
gem "httparty", "~> 0.20.0"

# = Error Tracking =
gem "honeybadger", "~> 4.12"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "webmock"
end

group :development do
  gem "web-console"
  gem "mdns", require: false
  gem "rack-mini-profiler"
  gem "stackprof"
  gem "bullet"
  gem "foreman"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "email_spec"
end
