# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.precompile += %w( favicon.png )
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts", "bootstrap-icons")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "images", "vendor")

Rails.application.config.assets.precompile += %w(
  vendor/bootstrap.min.css
  vendor/bootstrap-icons.css
)
