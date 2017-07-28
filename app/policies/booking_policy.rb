class BookingPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user == record.user && super
  end

  def create?
    user == record.user
  end

  def cancel?
    user == record.user && record.can_cancel?
  end

  class Scope < Scope
    def resolve
      user.bookings
    end
  end
end
