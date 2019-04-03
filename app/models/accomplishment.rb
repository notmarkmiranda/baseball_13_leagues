class Accomplishment < ApplicationRecord
  belongs_to :team
  belongs_to :game

  default_scope { order(:date) }
end
