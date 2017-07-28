module ActiveAdmin::ViewsHelper
  def booking_status_class(booking)
    case booking.status
    when "processed" then :ok
    when "canceled"  then :error
    else nil
    end
  end

  def print_booking(booking)
    "##{booking.id} - #{booking.booking_type.to_s.humanize} - #{format_date_month(booking.created_at)}"
  end

  def print_item(item)
    "##{item.id} - physical id #{item.physical_id}"
  end

  def print_location(location)
    "R #{location.row} - B #{location.bay} - H #{location.height}"
  end
end
