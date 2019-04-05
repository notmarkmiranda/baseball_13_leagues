namespace :after_party do
  desc 'Deployment task: import_games'
  task import_all_games: :environment do
    puts "Running deploy task 'import_all_games'"

    (Date.new(2019, 03, 28)..Date.today).each do |date|
      # make the existing import_yesterday rake task into a class, or extract to existing import_day class
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
