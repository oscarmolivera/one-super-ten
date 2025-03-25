class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  
  belongs_to :tenant
  acts_as_tenant(:tenant)

  enum :role, { super_admin: -1, user: 0, admin: 1, coach: 2, player: 3 }

  def super_admin?
    role == "super_admin"
  end
  
  def admin?
    role == "admin"
  end

  def coach?
    role == "coach"
  end

  def user?
    role == "user"
  end

  def player?
    role == "player"
  end

  def self.find_for_database_authentication(warden_conditions)
    where(email: warden_conditions[:email], tenant_id: ActsAsTenant.current_tenant&.id).first
  end
end
