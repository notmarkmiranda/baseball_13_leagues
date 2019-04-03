class ImportDay
  attr_reader :raw_json

  def initialize(json)
    @raw_json = json
  end

  def import!
    games&.each do |game_json|
      game_status = game_json[:status][:status]
      game_type = game_json[:series]
      ImportGame.import!(game_json, game_date) if game_status == 'Final' && game_type == "Regular Season"
    end
  end

  def self.lets_go!(json)
    new(json).import!
  end

  private

  def game_date
    date = parsed_json[:data][:games]
    Date.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
  end

  def games
    parsed_json[:data][:games][:game]
  end

  def parsed_json
    @parsed_json ||= JSON.parse(raw_json).with_indifferent_access
  end
end
