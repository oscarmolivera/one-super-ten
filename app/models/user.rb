class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :tenant
  acts_as_tenant(:tenant)

  enum role: { super_admin: -1, admin: 0, coach: 1, player: 2 } # Define roles

  def super_admin?
    role == "super_admin"
  end
  
  def admin?
    role == "admin"
  end

  def coach?
    role == "coach"
  end

  def player?
    role == "player"
  end
end
