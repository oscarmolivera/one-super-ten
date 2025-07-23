# lib/active_storage/service/custom_r2_public_service.rb
require "active_storage/service/s3_service"

module ActiveStorage
  class Service::CustomR2PublicService < Service::S3Service
    def url(key, **options)
      "https://cdn.nubbe.net/#{key}"
    end
  end
end