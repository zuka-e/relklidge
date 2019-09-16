class Admin::UsersController < ApplicationController

  def index
    @users = User.page(params[:page])
    @users = @users.where(["name LIKE ?", "%#{params[:name]}%"]) if params[:name].present?
    # @items = @items.where(["artist_id = ?","#{params[:artist]}"]) if params[:artist].present?
    # @items = @items.where(["genre_id = ?", "#{params[:genre]}"]) if params[:genre].present?
    # @items = @items.where(["sales_status = ?", "#{params[:sales_status]}"]) if params[:sales_status].present?
    # if params[:key].present?
    #   @items ||= @items.reorder("#{params[:key]} #{params[:direction]}")
    #   @sort = sorted( @items, params[:key],params[:direction] )
    #   @items = Kaminari.paginate_array(@sort).page(params[:page]).per(25)
    # end
  end

  def show
  end
end
