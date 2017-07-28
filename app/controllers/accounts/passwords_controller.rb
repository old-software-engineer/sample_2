class Accounts::PasswordsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :reset]

  def edit
  end

  def update
    unless @user.valid_password? user_params[:current_password]
      redirect_to edit_account_password_path, alert: 'You must provide a valid current password'
      return
    end

    password_attributes = user_params.select do |key, value|
      %w(password password_confirmation).include?(key.to_s)
    end

    if @user.update_attributes(password_attributes)
      flash[:notice] = "Password was successfully updated. Please login with it"
      redirect_to new_user_session_path
    else
      @user.reload
      render 'edit'
    end
  end

  def reset
    @user.send_reset_password_instructions
    redirect_to account_path, notice: 'We sent you an email with reset password instructions'
  end

  private
    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
end
