json.pick_up do
  json.partial! "bookings/booking", booking: @pick_up
end

if @empty_box_delivery
  json.empty_box_delivery do
    json.partial! "bookings/booking", booking: @empty_box_delivery
  end
end
