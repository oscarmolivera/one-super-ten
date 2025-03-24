class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  acts_as_tenant(:tenant)
end
