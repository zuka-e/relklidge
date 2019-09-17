class Admin::UsersController < ApplicationController

  def index
    if params[:name].present?
      @users = @users.where(["name LIKE ?", "%#{params[:name]}%"])
    else
      @users = User.page(params[:page])
    end
  end

  def show
  end
end
