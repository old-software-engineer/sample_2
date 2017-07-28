class Bookings::ItemDeliveryController < Bookings::ApplicationController
  def new
    @contact = current_user.contact || Contact.new
    @items = current_user.items

    if items_params[:item_ids]
      @items = @items.in_storage.find items_params[:item_ids]
    else
      @items = @items.none
    end
  end

  def create
    @items = current_user.items.in_storage.find(booking_items_params[:items].map { |item| item[:id] })
    @booking = bookings_scope.new booking_params.merge(booking_type: "delivery", items: @items)

    @booking.booking_items.each do |booking_item|
      item = booking_item.item
      item_param = booking_items_params[:items].find { |i| i[:id].to_i == item.id }

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

  private
    def items_params
      params.permit(item_ids: [])
    end
end
