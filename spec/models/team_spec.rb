require 'rails_helper'

describe Team, type: :model do
  describe 'relationships' do
    it { should have_many :home_games }
    it { should have_many :away_games }
    it { should have_many :ownerships }
    it { should have_many :accomplishments }
  end

  describe 'validations'
  describe 'methods' do
    let(:league) { create(:league, start_date: Date.new(2019, 01, 01)) }
    let(:team) { create(:team) }

    describe '#accomplishhments_count_by_league' do
      subject { team.accomplishment_count_by_league(league) }

      describe 'with zero accomplishments' do
        it 'returns a 0 for a team without accomplishments' do
          expect(subject).to eq(0)
        end
      end

      describe 'with one accomplishment' do
        before { create(:accomplishment, team: team, date: Date.today) }

        it 'returns a 1 for a team with an accomplishment' do
          expect(subject).to eq(1)
        end
      end
    end

    describe '#owner_email' do
      subject { team.owner_email_by_league(league) }
      let!(:owner) { create(:ownership, team: team, league: league).user }
      let(:owner_email) { 'superduper@superduper.com' }

      before { owner.update(email: owner_email  ) }

      it 'returns the users email' do
        expect(subject).to eq(owner_email )
      end
    end

    describe 'owned, unowned, and ordered teams' do
      let!(:unowned_team) { create(:ownership).team }
      let!(:owned_team) { create(:ownership, league: league).team }

      describe 'self#owned_teams_by_league' do
        subject { described_class.owned_teams_by_league(league) }

        it 'returns owned teams in the league' do
          expect(subject).to include(owned_team)
          expect(subject).not_to include(unowned_team)
        end
      end

      describe 'self#ordered_teams_by_league' do
        subject { described_class.ordered_teams_by_league(league) }

        it 'returns the teams in order' do
          results = subject

          expect(results.first).to eq(owned_team)
          expect(results.last).to eq(unowned_team)
        end
      end

      describe 'self#unowned_teams_by_league' do
        subject { described_class.unowned_teams_by_league(league) }

        it 'should return unowned teams in the league' do
          expect(subject).to include(unowned_team)
          expect(subject).not_to include(owned_team)
        end
      end
    end
  end
end
