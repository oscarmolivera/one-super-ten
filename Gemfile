source "https://rubygems.org"
ruby ">= 3.2.3", "< 4.0"

gem "acts_as_tenant", "~> 1.0"
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise", "~> 4.9"
gem "jbuilder"
gem "jsbundling-rails"
gem "kamal", require: false
gem "propshaft"
gem "pg", "~> 1.6"
gem "puma", ">= 5.0"
gem "pundit", "~> 2.5"
gem "rails", "~> 8.0.2"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "sqlite3", "~> 2.7"
gem "stimulus-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  # Temporary Heroku fix for net-pop / net-protocol issue
  gem 'net-pop', '~> 0.1.2'
  gem 'net-protocol', '~> 0.2.2'
end

group :development do
  gem "web-console"
end
group :staging do
  gem "rails_12factor", "~> 0.0.3"
end
