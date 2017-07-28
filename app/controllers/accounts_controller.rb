class AccountsController < ApplicationController
  def show
    @user = current_user
    @contact = current_user.contact || Contact.new
  end
end
