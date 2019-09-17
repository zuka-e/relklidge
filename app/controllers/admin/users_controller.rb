class Admin::UsersController < ApplicationController

  def index
    @users = User.page(params[:page])
    @users = @users.where(["name LIKE ?", "%#{params[:name]}%"]) if params[:name].present?
  end

  def show
  end
end
