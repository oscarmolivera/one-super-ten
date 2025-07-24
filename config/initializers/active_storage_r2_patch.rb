# config/initializers/active_storage_r2_patch.rb

Rails.application.config.to_prepare do
  ActiveStorage::Blob.singleton_class.prepend(Module.new {
    def build_after_upload(io:, filename:, content_type:, metadata: nil, service_name: nil)
      # Skip non-default checksums (SHA256 etc.) to avoid triggering R2's error
      new(
        filename: filename,
        content_type: content_type,
        metadata: metadata || {},
        service_name: service_name,
        byte_size: io.size,
        checksum: compute_md5_checksum(io)
      )
    end

    private

    def compute_md5_checksum(io)
      require "digest/md5"
      io.rewind
      Digest::MD5.base64digest(io.read.tap { io.rewind })
    end
  })
end