class Category < ApplicationRecord
  has_many :sections, inverse_of: :category
  accepts_nested_attributes_for :sections, allow_destroy: true
  attachment :image

  validates :name,
    presence: { message: "分類名を入力してください" },
    uniqueness: { case_sensitive: false, message: "この分類は既に使用されています" }

end
