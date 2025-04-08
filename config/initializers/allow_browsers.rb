Rails.application.config.to_prepare do
  ApplicationController.allow_browser(
    versions: {
      chrome: ">= 115",
      chromium: ">= 132",
      safari: ">= 15",
      firefox: ">= 110",
      edge: ">= 110"
    }
  )
end