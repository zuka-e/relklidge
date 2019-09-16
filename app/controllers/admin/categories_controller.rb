class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.page(params[:page])
  end

  def new
  end

  def edit
  end
end
