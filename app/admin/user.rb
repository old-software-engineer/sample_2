ActiveAdmin.register User do
  filter :email
  filter :active

  config.batch_actions = false

  sidebar "User Details", only: [ :show ] do
    ul do
      li link_to "Items", admin_user_user_items_path(resource)
      li link_to "Item Stocks", admin_user_user_item_stocks_path(resource)
      li link_to "Bookings", admin_user_user_bookings_path(resource)
      li link_to "Booking Items", admin_user_user_booking_items_path(resource)
      li link_to "Contacts", admin_user_user_contacts_path(resource)
      li link_to "Invoices", admin_user_user_invoices_path(resource)
    end
  end

  index do
    id_column
    column "Full name" do |user|
      if user.contact
        user.contact.full_name
      end
    end
    column :email
    column :active
    column :sign_in_count
    column :confirmed_at
    column :confirmation_sent_at
    column :failed_attempts
    column :locked_at
    column :current_sign_in_ip
  end

  show do
    panel "Contact" do
      attributes_table_for resource do
        row :id
        row :email
        row :active
        if resource.contact
          row "Full name" do
            resource.contact.full_name
          end
          row "Address" do
            resource.contact.address
          end
          row "Phone" do
            resource.contact.phone
          end
        end
      end
    end

    panel "Authentication" do
      attributes_table_for resource do
        row :sign_in_count
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :confirmed_at
        row :confirmation_sent_at
        row :failed_attemps
        row :locked_at
        row :created_at
        row :updated_at
        row :identities do
          unless resource.identities.empty?
            table_for resource.identities do
              column :provider
              column :created_at
            end
          end
        end
      end
    end
  end

  before_create do |user|
    user.skip_confirmation!
  end

  before_update do |user|
    if user.confirmed_at.nil?
      user.skip_confirmation!
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    inputs do
      if f.object.new_record?
        input :email
        input :password
        input :password_confirmation
      else
        input :email, input_html: { disabled: true }
      end
      input :active
    end
    actions
  end

  permit_params(
    :email,
    :password,
    :password_confirmation,
    :active
  )
end
