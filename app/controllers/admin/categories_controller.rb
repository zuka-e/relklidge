class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.page(params[:page])
  end

  def new
    @category = Category.new
  end
  def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = '分類を追加しました'
			redirect_to [:admin, @category]
		else
			render 'new'
		end
  end
  def show
    @category = Category.find(params[:id])
  end
  def edit
    @category = Category.find(params[:id])
	end
  end
  private

    def category_params
      params.require(:category).permit(:name, :content, :image,
				sections_attributes: [:id, :name, :content, :_destroy,
          items_attributes: [:id, :name, :content, :_destroy,]
        ]
      )
    end

end
