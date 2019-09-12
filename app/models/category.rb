class Category < ApplicationRecord
  has_many :sections
  attachment :image
end
