class TagsController < ApplicationController
  def index
    @tags = Tag.page(params[:page])
  end
end
