require 'net/http'

class BaseballService
  attr_reader :uri

  def initialize(url)
    @uri = URI(url)
  end

  def self.go!(date)
    url = "http://gd2.mlb.com/components/game/mlb/year_#{date[:year]}/month_#{date[:month]}/day_#{date[:day]}/master_scoreboard.json"
    new(url).vamonos!
  end

  def vamonos!
    response = Net::HTTP.get(uri)
  end
end
