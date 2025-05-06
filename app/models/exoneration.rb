class Exoneration < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :player

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  def active?(date = Date.today)
    start_date <= date && end_date >= date
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "must be after start date") if end_date < start_date
  end
end