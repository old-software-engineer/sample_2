class BookingItem < ApplicationRecord
  belongs_to :booking
  belongs_to :item
  delegate :user, to: :booking

  validates :booking, presence: true
  validates :item, presence: true, uniqueness: { scope: [:booking] }
  validates(
    :quantity_ordered,
    numericality: {
      greater_than_or_equal_to: 0,
      only_integer: true
    }
  )

  validate :validate_item_owner

  def validate_item_owner
    if item && booking && (item.user != booking.user)
      errors.add(:base, "Cannot book for item. Owner of item is different from the owner of booking")
    end
  end

  scope :latest, -> {
    order(id: :desc)
  }

  scope :total_volume, -> {
    joins(:item).sum("booking_items.quantity_ordered * items.volume")
  }
end
