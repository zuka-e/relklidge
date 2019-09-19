class Category < ApplicationRecord
  has_many :sections, inverse_of: :category
  accepts_nested_attributes_for :sections, allow_destroy: true
  attachment :image
end
