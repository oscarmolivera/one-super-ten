class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable,
          :lockable, :timeoutable
  rolify

  belongs_to :tenant
  acts_as_tenant(:tenant)

  has_one :coach_profile, dependent: :destroy

  has_many :coach_categories, foreign_key: :user_id, class_name: 'CategoryCoach'
  has_many :categories, through: :coach_categories

  # Assistant coaches (could be other Users with a special role or attribute)
  has_many :assistant_assignments, foreign_key: :coach_id, class_name: 'AssistantAssignment', dependent: :destroy
  has_many :assistants, through: :assistant_assignments, source: :assistant

  has_many :coach_assignments, foreign_key: :assistant_id, class_name: 'AssistantAssignment', dependent: :destroy
  has_many :coaches, through: :coach_assignments, source: :coach

  # Helper scopes
  scope :coaches, -> { with_role(:coach) }

  # Optional
  accepts_nested_attributes_for :coach_profile

  def full_name
    "#{first_name} #{last_name}"
  end

  def can_view_schedules?
    is_role_tenant_admin?
  end

  def can_manage_appointments?
    is_role_staff_assistant?
  end

  def super_admin?
    has_role?(:super_admin)
  end

  def is_role_tenant_admin?
    has_role?(:tenant_admin, ActsAsTenant.current_tenant)  
  end
  
  def is_role_staff_assistant?
    has_role?(:staff_assistant, ActsAsTenant.current_tenant)  
  end

  def is_role_coach?
    has_role?(:coach, ActsAsTenant.current_tenant)  
  end

  def role_name
    roles.first&.name.to_s.downcase
  end

  def add_role_with_tenant(role_name, resource = nil)
    roles.create(name: role_name, resource: resource, tenant: self.tenant)
  end

  def has_role?(role_name, resource = nil)
    if resource
      super(role_name, resource)
    else
      roles.exists?(name: role_name, tenant: ActsAsTenant.current_tenant)
    end
  end
  

  def self.find_for_database_authentication(warden_conditions)
    where(email: warden_conditions[:email], tenant: ActsAsTenant.current_tenant).first
  end
end
