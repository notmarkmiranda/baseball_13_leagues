class ImportDay
  attr_reader :raw_json

  def initialize(json, date)
    @raw_json = json
    @date = date || Date.today
  end

  def import!
    games&.each do |game_json|
      game_status = game_json[:status][:status]
      game_type = game_json[:series]
      ImportGame.import!(game_json, game_date) if game_status == 'Final' && game_type == "Regular Season"
    end
  end

  def self.lets_go!(date = nil)
    date = date || make_date_hash
    json = BaseballService.go!(date)
    new(json, date).import!
    Event.create!(event_type: 'ImportGame')

    League.active.each do |league|
      WinnerChecker.check_for_winner(league)
    end
  end

  private

  def game_date
    date = parsed_json[:data][:games]
    Date.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
  end

  def games
    parsed_json[:data][:games][:game]
  end

  def make_date_hash
    today = Date.today
    {
      year: today.year,
      month: format_number(today.month),
      day: format_number(today.day)
    }
  end

  def format_number(num)
    return "%02d" % num if num < 10
    num
  end

  def parsed_json
    @parsed_json ||= JSON.parse(raw_json).with_indifferent_access
  end
end
