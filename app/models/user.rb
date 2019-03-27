class User < ApplicationRecord
  has_many :leagues
  has_many :memberships

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :lockable

  enum role: [:member, :admin]
end
