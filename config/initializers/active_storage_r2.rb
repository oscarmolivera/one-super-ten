Rails.application.config.after_initialize do
  ActiveStorage::Service.url_extractor = lambda do |blob, **options|
    if blob.service.name == "r2_public"
      # Custom public URL
      "https://cdn.nubbe.net/#{blob.key}"
    else
      blob.service_url(**options)
    end
  end
end