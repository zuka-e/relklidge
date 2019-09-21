class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id,
    presence: { scope: :post_id },
    uniqueness: { scope: :post_id }

end
