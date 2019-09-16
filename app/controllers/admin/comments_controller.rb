class Admin::CommentsController < ApplicationController
  def index
    @comments = Comment.page(params[:page])
  end
end
