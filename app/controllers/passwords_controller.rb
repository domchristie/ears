class PasswordsController < ApplicationController
  before_action :authenticate
  layout "forms"

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if !@user.authenticate(params[:current_password])
      redirect_to edit_password_path, alert: "Incorrect password"
    elsif @user.update(user_params)
      redirect_to root_path, notice: "Password updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
