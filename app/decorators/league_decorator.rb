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
    elements << h.content_tag(:div, nested_elements_for_team_ownership(team), class: 'paid-section')
    elements.join.html_safe
  end

  def nested_elements_for_team_ownership(team)
    return unless object.is_admin?(h.current_user)
    elements = []
    elements << mark_as_button(team)
    elements << h.content_tag(:div, paid_status(team), class: 'paid-text')
    elements.join.html_safe
  end

  def mark_as_button(team)
    return mark_as_unpaid(team) if team.is_paid_in_league?(object)
    mark_as_paid(team)
  end

  def mark_as_paid(team)
    h.button_to h.mark_as_paid_league_ownership_path(object, ownership(object, team)), method: :patch, class: 'mark-as-button mark-as-paid-button', data: { toggle: "tooltip", placement: "top" }, title: button_tooltip_text(team) do
      h.fa_icon('check-circle')
    end
  end

  def mark_as_unpaid(team)
     h.button_to h.mark_as_unpaid_league_ownership_path(object, ownership(object, team)), method: :patch, class: 'mark-as-button mark-as-unpaid-button', data: { toggle: "tooltip", placement: "top" }, title: button_tooltip_text(team) do
      h.fa_icon('times-circle')
    end
  end

  def button_tooltip_text(team)
    ownership(object, team).paid? ? 'Mark as unpaid' : 'Mark as paid'
  end

  def ownership(league, team)
    Ownership.find_by(league: league, team: team)
  end
end
