require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Eager load code on boot for better performance.
  config.eager_load = true

  # Show full error reports (optional; set to false if you want to mimic production).
  config.consider_all_requests_local = true

  # Enable caching (similar to production).
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = true
  config.cache_store = :solid_cache_store
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{2.days.to_i}"
  }

  # Store uploaded files on local system. Use :amazon or :google for cloud.
  config.active_storage.service = :local

  # Mailer config
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'mykos.shop', protocol: 'https' }

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

  # Background job log info
  config.active_job.verbose_enqueue_logs = true

  # Raise error if before_action references non-existing actions
  config.action_controller.raise_on_missing_callback_actions = true

  # Require master key for encrypted credentials
  config.require_master_key = true

  config.hosts << /.*\.mykos\.shop/
end
