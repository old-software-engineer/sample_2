class Bookings::ApplicationController < ApplicationController
  protected
    def bookings_scope
      policy_scope Booking
    end

    def booking_params
      params.require(:booking).permit(
        :address,
        :contact_name,
        :contact_phone,
        :email,
        :suburb,
        :city,
        :state,
        :country,
        :reference
      )
    end

    def booking_items_params
      params.permit(items: [:id, :quantity])
    end
end
