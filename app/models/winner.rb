class Winner < ApplicationRecord
  belongs_to :league
  belongs_to :user
  belongs_to :accomplishment, optional: true

  def confirm!
    update(confirmed: true)
  end
end
