class User < ApplicationRecord
  # クラス属性を定義
  # user#createで所持させ,有効化メールに添付 [複数箇所で利用] -> userの属性とすることで値を維持
  attr_accessor :activation_token
  has_secure_password
  attachment :image
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :post, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post, dependent: :destroy
  has_many :favorite_tags, dependent: :destroy
  has_many :tags, through: :favorite_tags
  enum is_quit: { 利用中: false, 退会済: true }

  validates :name,
    presence: { message: "ユーザ名を入力してください" },
    format: { with: /\A\w+\z/, message: "使用できるのは、英数字、アンダーバー(_) のみです" },
    length: { minimum: 2, maximum: 20,  message: "ユーザ名は2文字以上、20文字以内で入力してください" },
    uniqueness: { case_sensitive: false, message: "このユーザ名は既に使用されています" }
  validates :email,
    presence: { message: "メールアドレスを入力してください" },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "有効なメールアドレスを入力してください" },
    uniqueness: { case_sensitive: false, message: "このメールアドレスは既に使用されています" }
  validates :password,
    presence: { message: "パスワードを入力してください" },
    length: { minimum: 8, message: "パスワードは8文字以上で入力してください" },
    allow_nil: true

  def User.digest(string) # 引数をハッシュ化
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
