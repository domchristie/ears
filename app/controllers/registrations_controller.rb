class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  layout "forms"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
      send_email_verification
      redirect_to root_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
