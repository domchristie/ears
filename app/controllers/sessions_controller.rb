class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  layout "forms"

  def new
    redirect_to root_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      sign_in user
      redirect_to root_path
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: t(".failure")
    end
  end

  def destroy
    session = Current.user.sessions.find(params[:id])
    session.destroy
    redirect_to sign_in_path, notice: t(".success")
  end
end
