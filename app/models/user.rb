class User < ApplicationRecord
  has_many :identities, dependent: :destroy
  has_many :bookings
  has_many :booking_items, through: :bookings
  has_many :items
  has_many :item_stocks, through: :items
  has_many :contacts
  has_many :invoices

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  def sign_in_info
    { sign_in_count: sign_in_count }
  end

  def contact
    contacts.first
  end

  scope :order_by_email, -> {
    order(email: :asc)
  }
end
