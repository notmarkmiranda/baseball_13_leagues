namespace :after_party do
  desc 'Deployment task: create_all_mlb_teams'
  task create_all_teams: :environment do
    puts "Running deploy task 'create_all_teams'"

    CreateAllTeams.lets_go!

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
