Rails.application.reloader.to_prepare do
  Rolify.configure("Role") do |config|
    config.use_dynamic_shortcuts
  end
end