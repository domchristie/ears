class Users::DashboardsController < ApplicationController
  def show
    @dashboard = User::Dashboard.new
  end
end
