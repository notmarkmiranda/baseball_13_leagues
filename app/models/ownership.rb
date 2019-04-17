class Ownership < ApplicationRecord
  belongs_to :user
  belongs_to :league
  belongs_to :team

  accepts_nested_attributes_for :user

  validates :user_id, uniqueness: { scope: :league_id }
  validates :team_id, uniqueness: { scope: :league_id }

  def mark_as_paid!
    update(paid: true)
  end

  def mark_as_unpaid!
    update(paid: false)
  end
end
