class User < ApplicationRecord
  has_secure_password
  attachment :image
  has_many :posts
end
