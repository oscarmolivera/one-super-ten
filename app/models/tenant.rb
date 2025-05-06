class Tenant < ApplicationRecord
  belongs_to :parent_tenant, class_name: 'Tenant', optional: true
  has_many :subtenants, class_name: 'Tenant', foreign_key: 'parent_tenant_id'
  has_many :roles, inverse_of: :tenant
  has_many :users
  has_many :landings
  has_many :schools, dependent: :destroy
  has_many :categories, through: :schools
  has_many :players, dependent: :destroy
  has_many :incomes, dependent: :destroy

  before_validation :set_default_parent, on: :create

  validates :subdomain, presence: true, uniqueness: true

  def theme_color
    self[:theme_color] || '#f0f0f0'
  end

  def schedules
    5
  end

  def citas
    3
  end

  private

  def set_default_parent
    self.parent_tenant ||= Tenant.find_by(subdomain: 'main')
  end
end