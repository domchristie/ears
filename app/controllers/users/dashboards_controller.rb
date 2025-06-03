class Users::DashboardsController < ApplicationController
  def show
    @dashboard = Dashboard.new(Current.user)
  end
end
