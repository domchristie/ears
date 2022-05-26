class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      after_login_path = session[:user_return_to] || root_path
      active_session = login @user
      remember(active_session) if params[:user][:remember_me] == "1"
      redirect_to after_login_path
    else
      flash.now[:alert] = "Incorrect email"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to root_path, notice: "Signed out."
  end
end
