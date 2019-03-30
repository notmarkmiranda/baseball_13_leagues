class Ownership < ApplicationRecord
  belongs_to :user
  belongs_to :league
  belongs_to :team

  validates :user_id, uniqueness: { scope: :league_id }
end
