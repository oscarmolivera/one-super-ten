# lib/active_storage/service/custom_r2_private_service.rb
require "active_storage/service/s3_service"

class ActiveStorage::Service::CustomR2PrivateService < ActiveStorage::Service::S3Service
  def initialize(bucket:, **options)
    super(
      bucket: bucket,
      **options.merge(
        http_open_timeout: 5,
        http_read_timeout: 5,
        ssl_verify_peer: true
      )
    )
  end

  def upload(key, io, checksum: nil, **_ignored)
    instrument :upload, key: key, checksum: checksum do
      obj = object_for(key)
      obj.put(body: io.read) # ⚠️ NO METADATA, NO MD5 headers
    end
  end
end