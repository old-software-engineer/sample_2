class AddColumnStatusToBooking < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :status, :integer, default: 0

    Booking.find_each do |booking|
      if booking.canceled?
        booking.status = 2
      elsif booking.booked_date.to_date < Time.zone.today.to_date
        booking.status = 1
      end

      booking.save(validate: false)
    end
  end
end
