class CreateAllTeams
  def self.lets_go!
    Teams::ALL_TEAMS.each do |team|
      new_team = Team.find_or_create_by(mlb_id: team[0], name: team[1])
      puts "#{new_team.name}!"
    end

    puts "There are #{Team.all.count} teams!"
  end
end
