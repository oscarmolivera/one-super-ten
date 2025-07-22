require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Eager load code on boot for better performance.
  config.eager_load = true

  # Show full error reports (optional; set to false if you want to mimic production).
  config.consider_all_requests_local = true

  # Enable caching (similar to production).
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = true
  config.cache_store = :solid_cache_store, { compression: true }
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{2.days.to_i}"
  }

  # Storage configuration
  config.active_storage.service = :r2_private

  # Mailer config
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: ENV["APP_DOMAIN"], protocol: 'https' }

  # Uncomment and configure this block if sending real emails in staging:
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   address:              "smtp.mailgun.org",  # or your provider
  #   port:                 587,
  #   domain:               "mykos.shop",
  #   user_name:            ENV["SMTP_USERNAME"],
  #   password:             ENV["SMTP_PASSWORD"],
  #   authentication:       "plain",
  #   enable_starttls_auto: true
  # }

  # Use Sidekiq or another queue adapter in staging
  # config.active_job.queue_adapter = :sidekiq
  # config.active_job.queue_name_prefix = "mykos_staging"

  # Logging
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::Logger.new(STDOUT)

  # Deprecation & database behavior
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_record.dump_schema_after_migration = false

# View rendering
config.action_view.annotate_rendered_view_with_filenames = true

# Asset handling
config.assets.compile = false

# Background job log info
config.active_job.verbose_enqueue_logs = true

  # Raise error if before_action references non-existing actions
  config.action_controller.raise_on_missing_callback_actions = true

  # Redirect www to non-www
  config.middleware.insert_before(0, Rack::Rewrite) do
    r301 %r{.*}, 'https://nubbe.net$&', if: Proc.new { |rack_env|
      rack_env['HTTP_HOST'] == 'www.nubbe.net'
    }
  end

  # Require master key for encrypted credentials
  config.require_master_key = true
  config.force_ssl = true
  config.active_record.encryption.encrypt_fixtures = true
  config.active_record.encryption.log_on_unencrypted_access = :warn

  if ENV["APP_DOMAIN"].present?
    domain = ENV["APP_DOMAIN"].gsub(".", '\.')
    config.hosts << /.*\.#{domain}/
    config.hosts << ENV["APP_DOMAIN"]
  end

  config.hosts << "nubbe-ost-3926c7d2da80.herokuapp.com"
end
