class AddImageIdToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :image_id, :string
  end
end
