class User < ApplicationRecord
  has_secure_password
  has_one_attached :icon

  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: VALID_EMAIL_REGEX }

  validates :password, length: { minimum: 6 }
end
