class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag

  validates :tag_id,
    presence: { scope: :post_id },
    uniqueness: { scope: :post_id }

end
