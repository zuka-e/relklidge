class Item < ApplicationRecord
  belongs_to :section
  has_many :item_tags
  has_many :tags, through: :item_tags
end
