class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  layout "forms"

  def new
    redirect_to root_path if authenticated?
  end

  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      start_new_session_for user
      redirect_to root_path
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: t(".failure")
    end
  end

  def destroy
    terminate_session
    redirect_to sign_in_path, notice: t(".success")
  end
end
