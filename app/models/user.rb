class User < ApplicationRecord
  has_many :user_points
  before_create :generate_user_token

  def generate_user_token
    self.user_token = loop do
      token = SecureRandom.hex
      break token unless User.exists?(user_token: token)
    end
  end
end
