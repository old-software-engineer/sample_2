ActiveAdmin.register ItemStock do
  filter :booking, collection: proc { Booking.latest.take(100).map { |b| [print_booking(b), b.id] } }
  filter :adjustment_type, as: :select, collection: proc { ItemStock.adjustment_types.to_a }
  filter :created_at
  filter :updated_at

  config.batch_actions = false
  actions :index, :show, :edit, :update, :destroy
  config.clear_action_items!

  action_item :edit, only: :show do
    raw item_stock_action_links(resource)
  end

  includes item: [:user], booking_item_stock: [:booking]

  index do
    id_column
    column "User" do |item_stock|
      link_to item_stock.item.user.email, admin_user_path(item_stock.item.user)
    end
    column "Item" do |item_stock|
      link_to item_stock.item.id, admin_item_path(item_stock.item)
    end
    column :adjustment_type
    column :quantity_diff
    column :quantity_in_storage
    column "Booking" do |item_stock|
      if item_stock.booking_item_stock
        link_to item_stock.booking_item_stock.booking.id, admin_booking_path(item_stock.booking_item_stock.booking)
      end
    end
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :id
      row "User" do |item_stock|
        link_to item_stock.item.user.email, admin_user_path(item_stock.item.user)
      end
      row "Item" do |item_stock|
        link_to item_stock.item.id, admin_item_path(item_stock.item)
      end
      row :quantity_in_storage
      row :quantity_diff
      row :adjustment_type
      row "Booking" do |item_stock|
        if item_stock.booking_item_stock
          link_to item_stock.booking_item_stock.booking.id, admin_booking_path(item_stock.booking_item_stock.booking)
        end
      end
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    inputs do
      if f.object.can_update_quantity?
        input :quantity_diff
        input :adjustment_type
      else
        li do
          attributes_table_for f.object do
            row :quantity_diff
            row :adjustment_type
          end
        end
      end
      input :description
    end
    actions
  end

  permit_params(
    :quantity_diff,
    :adjustment_type,
    :description
  )
end

ActiveAdmin.register ItemStock, as: "User Item Stocks" do
  menu parent: "User", label: "User Item Stocks"

  filter :booking, collection: proc { parent.bookings.latest.take(100).map { |b| [print_booking(b), b.id] } }
  filter :adjustment_type, as: :select, collection: proc { ItemStock.adjustment_types.to_a }
  filter :item, collection: proc { parent.items.latest.map { |i| [print_item(i), i.id] } }
  filter :created_at
  filter :updated_at

  actions :index

  belongs_to :user

  batch_action :select_booking, form: -> {
    user = User.find params[:user_id]
    { booking: user.bookings.latest.take(100).map { |b| ["##{b.id} - #{b.booking_type} - #{b.created_at.strftime("%d %b %Y")}", b.id] } }
  } do |ids, inputs|
    unless inputs[:booking].nil?
      user = User.find params[:user_id]
      booking = user.bookings.find inputs[:booking]
      item_stocks = user.item_stocks.find ids

      ItemStock.batch_save_booking(booking, item_stocks)

      notice = "Booking: #{booking.id} Item Stocks: #{ids.join(', ')}"
      redirect_to admin_user_user_item_stocks_path(user), notice: notice
    end
  end

  batch_action :remove_booking do |ids|
    user = User.find params[:user_id]
    item_stocks = user.item_stocks.find ids

    ItemStock.batch_remove_booking(item_stocks)

    notice = "Booking deleted from Item Stocks: #{ids.join(', ')}"
    redirect_to admin_user_user_item_stocks_path(user), notice: notice
  end

  controller do
    def scoped_collection
      parent.item_stocks.includes :item, booking_item_stock: [:booking]
    end
  end

  index title: ->{ "Item Stocks - #{parent.email}" } do
    selectable_column
    column "Id" do |item_stock|
      link_to item_stock.id, admin_item_stock_path(item_stock)
    end
    column "Item" do |item_stock|
      link_to item_stock.item.id, admin_item_path(item_stock.item)
    end
    column :adjustment_type
    column :quantity_diff
    column :quantity_in_storage
    column "Booking" do |item_stock|
      if item_stock.booking_item_stock
        link_to item_stock.booking_item_stock.booking.id, admin_booking_path(item_stock.booking_item_stock.booking)
      end
    end
    column :created_at
    column :updated_at
  end
end

ActiveAdmin.register ItemStock, as: "Item Item Stocks" do
  menu parent: "Item", label: "Item Item Stocks"

  filter :booking, collection: proc { parent.bookings.latest.take(100).map { |b| [print_booking(b), b.id] } }
  filter :adjustment_type, as: :select, collection: proc { ItemStock.adjustment_types.to_a }
  filter :created_at
  filter :updated_at

  config.batch_actions = false
  actions :index, :new, :create

  belongs_to :item

  controller do
    def scoped_collection
      parent.item_stocks.includes booking_item_stock: [:booking]
    end

    def create
      super location: admin_item_item_item_stocks_path(parent)
    end
  end

  index title: ->{ "Item Stocks - Item ##{parent.id}" } do
    column "Id" do |item_stock|
      link_to item_stock.id, admin_item_stock_path(item_stock)
    end
    column :adjustment_type
    column :quantity_diff
    column :quantity_in_storage
    column "Booking" do |item_stock|
      if item_stock.booking_item_stock
        link_to item_stock.booking_item_stock.booking.id, admin_booking_path(item_stock.booking_item_stock.booking)
      end
    end
    column :created_at
    column :updated_at
    actions defaults: false do |item_stock|
      raw item_stock_action_links(item_stock)
    end
  end

  form title: "New Item Stock" do |f|
    f.semantic_errors *f.object.errors.keys
    inputs do
      input :quantity_diff
      input :adjustment_type
      input :description
    end
    actions
  end

  permit_params(
    :quantity_diff,
    :adjustment_type,
    :description
  )
end

def item_stock_action_links(item_stock)
  links = link_to 'Edit', edit_admin_item_stock_path(item_stock), class: "member_link"

  if item_stock.can_destroy?
    links += link_to 'Delete', admin_item_stock_path(item_stock), method: :delete, data: { confirm: "Are you sure you want to DELETE this tracking?" }, class: "member_link"
  end

  links
end
