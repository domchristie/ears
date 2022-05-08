class Users::DashboardsController < ApplicationController
  def show
    @dashboard = User::Dashboard.new(Current.user)
  end
end
