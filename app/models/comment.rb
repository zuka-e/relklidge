class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

	validates :content, presence: { message: "本文を記述してください" }

end
