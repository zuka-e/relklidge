class Admin::CommentsController < ApplicationController
  def index
    @q = Comment.ransack(params[:q])
    @comments = @q.result(distinct: true).page(params[:page])
  end
end
