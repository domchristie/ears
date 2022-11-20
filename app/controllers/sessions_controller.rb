class SessionsController < ApplicationController
  before_action :authenticate, only: :destroy

  layout "forms"

  def new
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
