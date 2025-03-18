class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :tenant
  acts_as_tenant(:tenant)

  enum :role, { super_admin: -1, user: 0, admin: 1, coach: 2 }

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
end
