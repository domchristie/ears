class Users::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @dashboard = User::Dashboard.new(Current.user)
  end
end
