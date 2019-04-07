class LeagueDecorator < ApplicationDecorator
  delegate_all

  def active_status
    object.active? ? 'Active League' : 'Done'
  end

  def full_date(timeframe)
    object.send(timeframe).strftime("%B %-e, %Y")
  end

  def in_progress_text
    object.end_date ? full_date('end_date') : ' - In Progress'
  end

  def memberships_translator
    h.pluralize(object.memberships.count, 'player')
  end
end
