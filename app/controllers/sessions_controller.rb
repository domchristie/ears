class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase.strip)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "Incorrect email or password."
      elsif @user.authenticate(params[:user][:password])
        after_login_path = session[:user_return_to] || root_path
        login_and_remember @user
        redirect_to after_login_path
      else
        flash.now[:alert] = "Incorrect email or password."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to root_path, notice: "Signed out."
  end
end
