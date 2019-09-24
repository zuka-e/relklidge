class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :comments, source: :post, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  default_scope -> { order(created_at: :DESC) }
  default_scope -> { where(is_open: true) } # '非公開'は表示しない
  scope :unlimited , ->{ unscope(where: :is_open) } # Post.unlimitedで解除

  validates :title,
    presence: { message: "タイトルを入力してください" },
    length: { minimum: 1, maximum: 30,  message: "タイトルは1文字以上、30文字以内で入力してください" },
    uniqueness: { case_sensitive: false, message: "このタイトルは既に使用されています" }
  validates :content,
    presence: { message: "本文を入力してください" },
    length: { minimum: 2, maximum: 2000,  message: "本文は2文字以上、2000文字以内で入力してください" }

  def liked_by?(user)
    self.likes.exists?(user_id: user.id)
  end

end
