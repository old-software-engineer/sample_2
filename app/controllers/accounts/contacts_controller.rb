class Accounts::ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update]

  def new
    @contact = current_user.contacts.new
  end

  def create
    @contact = current_user.contacts.new contact_params

    respond_to do |format|
      if @contact.save
        format.html { redirect_to account_path, notice: 'Contact was successfully saved.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to account_path, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_contact
      @contact = current_user.contact
    end

    def contact_params
      params.fetch(:contact, {}).permit(
        :address,
        :phone,
        :first_name,
        :last_name,
        :suburb,
        :city,
        :state,
        :country
      )
    end
end
