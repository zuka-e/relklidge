class User < ApplicationRecord
  has_secure_password
  attachment :image
end
