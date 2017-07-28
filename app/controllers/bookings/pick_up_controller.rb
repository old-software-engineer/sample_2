class Bookings::PickUpController < Bookings::ApplicationController
  def new
    @contact = current_user.contact || Contact.new
    @items = current_user.items
  end

  def create
    items_params = booking_items_params[:items] || []

    @items = current_user.items.find(items_params.map { |item| item[:id] })
    @booking = bookings_scope.new booking_params.merge(booking_type: "pick_up", items: @items)

    @booking.booking_items.each do |booking_item|
      item = booking_item.item
      item_param = items_params.find { |i| i[:id].to_i == item.id }

      if item_param
        booking_item.quantity_ordered = item_param[:quantity]
      end
    end

    authorize @booking

    if @booking.save
      BookingMailer.notify_booking_created(current_user, @booking).deliver_later
      render json: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end
end
