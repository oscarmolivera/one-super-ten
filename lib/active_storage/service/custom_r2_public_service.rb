# lib/active_storage/service/custom_r2_public_service.rb
require "active_storage/service/s3_service"

class ActiveStorage::Service::CustomR2PublicService < ActiveStorage::Service::S3Service
  def initialize(bucket:, **options)
    super(
      bucket: bucket,
      **options.merge(
        http_open_timeout: 5,
        http_read_timeout: 5,
        ssl_verify_peer: false
      )
    )
  end

  def url(key, **options)
    "https://cdn.nubbe.net/#{key}"
  end
end