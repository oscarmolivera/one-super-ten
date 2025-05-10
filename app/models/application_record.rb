class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  
  def cache_key_with_version
    key = "#{self.class.name.underscore}/#{id}"
    key = "tenants/#{tenant_id}/#{key}" if respond_to?(:tenant_id)
    "#{key}-#{updated_at.to_i}"
  end
end
