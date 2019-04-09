require 'rails_helper'

describe 'Async league only shows relevant accomplishments' do
  let(:league_start) { Date.new(2015, 5, 9) }
  let(:late_start) { Date.new(2015, 5, 11) }

  let(:league) { create(:league, async_starts: true, start_date: league_start) }
  let(:ownership) { create(:ownership, league: league, start_date: late_start) }
  let(:team) { ownership.team }

  before do
    acc = create(:accomplishment, team: team, number: 1, date: league_start)
    Accomplishment.where.not(id: acc.id).destroy_all
  end

  it 'should not show the accomplishment on the page' do
    visit league_path(league)

    expect(page).to have_content(league.name)
    expect(page).not_to have_selector(:css, "i.fa.fa-check")
  end
end
