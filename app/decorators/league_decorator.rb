class LeagueDecorator < ApplicationDecorator
  delegate_all

  def active_status
    object.active? ? 'Active League' : 'Done'
  end

  def full_start_date
    start_date.strftime("%B %-e, %Y")
  end

  def memberships_translator
    h.pluralize(object.memberships.count, 'player')
  end
end
