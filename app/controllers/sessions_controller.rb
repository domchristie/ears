class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      login @user
      redirect_to root_path
    else
      flash.now[:alert] = "Incorrect email"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Signed out."
  end
end
