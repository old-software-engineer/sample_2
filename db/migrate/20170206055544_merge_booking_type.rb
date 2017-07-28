class MergeBookingType < ActiveRecord::Migration[5.0]
  def change
    Booking.find_each do |booking|
      if booking.booking_type.to_i == 2
        booking.booking_type = 1
      end

      booking.save(validate: false)
    end
  end
end
