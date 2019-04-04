class TeamDecorator < ApplicationDecorator
  delegate_all

  def progress_bar_numbers(league, range)
    "#{object.accomplishment_count_by_league(league)} / #{range.count} - #{completion_percentage_by_league(league)}%"
  end

  def completion_percentage_by_league(league)
    "#{(accomplishment_count_by_league(league) / 14.to_f * 100).floor}%"
  end
end
