namespace :import_yesterday do
  desc "TODO"
  task :all_games, [:year, :month, :day] => :environment do |task, args|
    all_args = [args[:year], args[:month], args[:day]]
    today = all_args.include?(nil) ?
            Date.today :
            Date.new(args[:year].to_i, args[:month].to_i, args[:day].to_i)

    date = {
      year: today.year,
      month: format_number(today.month),
      day: format_number(today.day)
    }

    ImportDay.lets_go!(date)
  end
end

def format_number(num)
  return "%02d" % num if num < 10
  num
end
