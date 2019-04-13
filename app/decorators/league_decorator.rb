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

  def owner_email_or_assignment_link(team)
    return team_owner(team) if Team.owned_teams_by_league(object).include?(team)
    return assignment_link(team) if h.policy(object).admin?
  end

  private

  def assignment_link(team)
    h.content_tag(:div) do
      h.link_to 'Assign Team', h.new_league_ownership_path(object, team_id: team.id), class: 'assign-team-link'
    end
  end

  def paid_status(team)
    team.ownership_status_by_league(object) ? 'Paid' : 'Not Paid'
  end

  def team_owner(team)
    elements = []
    elements << h.content_tag(:span, team.owner_email_by_league(object), class: 'ownership-text')
    elements << h.content_tag(:div, paid_status(team), class: 'paid-text mb-2')
    elements.join.html_safe
  end
end
