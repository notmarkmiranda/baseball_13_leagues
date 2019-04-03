require 'net/http'

class BaseballService
  attr_reader :uri

  def initialize(url)
    @uri = URI(url)
  end

  def self.go!(year:, month:, day:)
    url = "http://gd2.mlb.com/components/game/mlb/year_#{year}/month_#{month}/day_#{day}/master_scoreboard.json"
    new(url).vamonos!
  end

  def vamonos!
    response = Net::HTTP.get(uri)
  end
end
