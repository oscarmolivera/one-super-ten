class Guardian < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  belongs_to :player

  validates :first_name, :last_name, :relationship, :phone, presence: true
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  enum :gender, { male: "male", female: "female", other: "other" }
  enum :relationship, { padre: "padre", madre: "madre", familiar: "familiar",  tutor: "tutor" }  


  def full_name
    "#{first_name} #{last_name}"
  end
end