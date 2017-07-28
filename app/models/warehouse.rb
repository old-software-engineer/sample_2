class Warehouse < ApplicationRecord
  has_many :locations

  before_destroy :validate_can_destroy

  enum state: {
    act: 0,
    nsw: 1,
    nt: 2,
    qld: 3,
    sa: 4,
    tas: 5,
    wa: 6
  }

  validates :address_1,   presence: true, length: { maximum: 100 }
  validates :address_2,                   length: { maximum: 100 }
  validates :suburb,      presence: true, length: { maximum: 100 }
  validates :postal_code, presence: true, length: { maximum: 100 }
  validates(
    :capacity,
    numericality: {
      greater_than_or_equal_to: 0,
      only_integer: true
    }
  )

  def validate_can_destroy
    unless can_destroy?
      errors.add(:base, "Cannot delete record. There are locations registered for this warehouse")
      throw(:abort)
    end
  end

  def can_destroy?
    locations.empty?
  end
end
