class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def help
    @current_user = User.find_by(id: session[:user_id])
  end
end
