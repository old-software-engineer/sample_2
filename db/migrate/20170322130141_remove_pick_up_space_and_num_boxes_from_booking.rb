class RemovePickUpSpaceAndNumBoxesFromBooking < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :pick_up_space
    remove_column :bookings, :num_empty_boxes
  end
end
