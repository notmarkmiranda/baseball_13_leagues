class League < ApplicationRecord
  has_secure_token

  belongs_to :user
  has_many :memberships
  has_many :ownerships
  has_many :winners

  delegate :count, to: :memberships, prefix: true

  validates :name, presence: true, uniqueness: true
  validates :start_date, presence: true

  after_create :create_adminship

  scope :active, -> { where(active: true) }

  def confirmed_winners
    winners.where(confirmed: true)
  end

  def deactivate_only!
    update(active: false)
  end

  def end_today!
    update(end_date: Date.today) if end_date.nil?
  end

  def finalize!
    deactivate_only!
    end_today! if end_date.nil?
    winners.first.confirm!
  end

  def to_param
    token
  end

  def winners_count
    winners.count
  end

  def winning_teams
    winners.map do |winner|
      Ownership.find_by(league: winner.league, user: winner.user).team
    end
  end

  private

  def create_adminship
    memberships.create!(user: user, role: 1)
  end
end
