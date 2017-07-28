# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview
  def create
    booking = Booking.joins(:items).distinct.first
    BookingMailer.notify_booking_created(User.first, booking)
  end
end
