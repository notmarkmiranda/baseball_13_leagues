class User < ApplicationRecord
  has_many :leagues
  has_many :memberships
  has_many :winners

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :lockable

  enum role: [:member, :admin]

  def membered_or_admined_leagues
    League.joins(:memberships).where("memberships.user_id = ?", id)
  end
end
