json.extract! booking,
  :id,
  :created_at,
  :updated_at,
  :booking_type,
  :address,
  :contact_name,
  :contact_phone,
  :status,
  :tracking_id,
  :email,
  :reference

json.url booking_url(booking, format: :json)
