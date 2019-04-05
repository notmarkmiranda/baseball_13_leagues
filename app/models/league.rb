class League < ApplicationRecord
  has_secure_token

  belongs_to :user
  has_many :memberships
  has_many :ownerships

  delegate :count, to: :memberships, prefix: true

  validates :name, presence: true, uniqueness: true
  validates :start_date, presence: true

  after_create :create_adminship

  def to_param
    token
  end
  
  private

  def create_adminship
    memberships.create!(user: user, role: 1)
  end
end
