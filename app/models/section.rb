class Section < ApplicationRecord
  belongs_to :category
  has_many :items, inverse_of: :section
  accepts_nested_attributes_for :items, allow_destroy: true

end
