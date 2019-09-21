class Item < ApplicationRecord
  belongs_to :section
  has_many :item_tags
  has_many :tags, through: :item_tags

  validates :name,
    presence: { message: "項目名を入力してください" }

end
