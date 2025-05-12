class PasswordsController < ApplicationController
  layout "forms"

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if !@user.authenticate(params[:current_password])
      redirect_to edit_password_path, alert: t(".failure")
    elsif @user.update(user_params)
      redirect_to root_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
