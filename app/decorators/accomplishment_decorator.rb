class AccomplishmentDecorator < ApplicationDecorator
  delegate_all

  def short_date
    object.date.strftime("%m/%-e/%y")
  end
end
