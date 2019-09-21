class FavoriteTag < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :tag_id,
    presence: { scope: :user_id },
    uniqueness: { scope: :user_id }

end
