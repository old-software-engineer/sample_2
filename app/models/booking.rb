class Booking < ApplicationRecord
  belongs_to :user
  has_many :booking_items, inverse_of: :booking
  has_many :items, through: :booking_items
  has_many :booking_item_stocks
  has_many :item_stocks, through: :booking_item_stocks

  accepts_nested_attributes_for :booking_items, allow_destroy: true
  accepts_nested_attributes_for :item_stocks

  enum booking_type: {
    pick_up: 0,
    delivery: 1
  }

  enum status: {
    pending: 0,
    processed: 1,
    'Ready_to_Ship': 2,
    canceled: 3
  }

  validates :user, presence: true
  validates :address, presence: true, length: { maximum: 200 }
  validates :contact_name, presence: true, length: { maximum: 50 }
  validates :contact_phone, presence: true, length: { maximum: 20 }
  validate :validate_no_update_if_canceled, on: :update

  def validate_no_update_if_canceled
    if status_was == "canceled"
      errors.add(:base, "Cannot update. Booking was canceled")
    end
  end

  def mark_as_read
    unless read
      update_attribute :read, true
    end
  end

  def can_batch_create_item_stocks?
    item_stocks.empty?
  end

  def can_cancel?
    !new_record? && pending?
  end

  def cancel
    if can_cancel?
      canceled!
    end
  end

  def find_or_build_item_stocks
    if item_stocks.empty?
      adjustment_type = delivery? ? :delivery : :pick_up

      item_stocks_params = booking_items.map do |b|
        { item: b.item, quantity_diff: b.quantity_ordered, adjustment_type: adjustment_type }
      end

      item_stocks.build item_stocks_params
    else
      item_stocks
    end
  end

  scope :latest, -> { order(id: :desc) }
  scope :not_canceled, -> { where.not(status: :canceled) }
end
