class ImportGame
  attr_reader :json
  attr_reader :game_date

  def initialize(json, game_date)
    @json = json
    @game_date = game_date
  end

  def self.import!(json, game_date)
    new(json, game_date).create!
  end

  def create!
    g = Game.find_or_initialize_by(mlb_game_id: mlb_game_id)
    if g.new_record?
      g.home_team = home_team
      g.away_team = away_team
      g.home_team_score = home_team_score
      g.away_team_score = away_team_score
    end
    g.save!
  end

  private

  def away_team
    @away_team ||= Team.find_by_mlb_id(json[:away_team_id])
  end

  def away_team_score
    linescore_runs[:away].to_i
  end

  def home_team
    @home_team ||= Team.find_by_mlb_id(json[:home_team_id])
  end

  def home_team_score
    linescore_runs[:home].to_i
  end

  def linescore_runs
    json[:linescore][:r]
  end

  def mlb_game_id
    json[:gameday]
  end
end
