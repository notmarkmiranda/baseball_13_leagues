class League < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :start_date, presence: true
end
