require 'rails_helper'

describe WinnerChecker do
  let!(:ownership) { create(:ownership) }
  let(:league) { ownership.league }
  let(:owner) { ownership.user }
  let(:team) { ownership.team }

  subject { described_class.check_for_winner(league) }

  before do
    league.update(active: true, end_date: nil)
  end

  describe 'when there is a single winner' do
    before do
      14.times { |n| create(:accomplishment, number: n, team: team, date: Date.today) }
    end

    it 'declares a winner' do
      expect {
        subject
      }.to change(Winner, :count).by(1)

      league.reload

      expect(league.active).to be false
      expect(league.end_date).not_to be nil
      expect(Winner.last.confirmed).to be true
    end
  end

  describe 'when there is no winner' do
    before do
      13.times { |n| create(:accomplishment, number: n, team: team, date: Date.today) }
    end

    it 'should not create a winner' do
      expect {
        subject
      }.to change(Winner, :count).by(0)

      league.reload

      expect(league.active).to be true
      expect(league.end_date).to be nil
    end
  end

  describe 'when there are multiple winners' do
    let(:other_ownership) { create(:ownership, league: league) }
    let(:other_team) { other_ownership.team }
    let(:other_owner) { other_ownership.user }

    describe 'when there are two winners' do
      before do
        14.times do |n|
          create(:accomplishment, number: n, team: team, date: Date.today)
          create(:accomplishment, number: n, team: other_team, date: Date.today)
        end
      end

      it 'declares 2 winners' do
        expect {
          subject
        }.to change(Winner, :count).by(2)

        league.reload

        expect(league.active).to be true
        expect(league.end_date).not_to be nil
      end
    end

    describe 'for games on the following day' do
      before do
        league.winners.create(user: other_owner)
        league.winners.create(user: owner)
        league.end_today!
        create(:accomplishment, number: 2, team: team, date: Date.tomorrow)
        create(:accomplishment, number: 1, team: other_team, date: Date.tomorrow)
      end

      let(:winner_winner) { Winner.find_by(user: other_owner) }

      it 'declares a winner based on the game following the end date' do
        travel_to Date.tomorrow do
          subject

          expect(league.winners).to include(winner_winner)
          expect(league.end_date).not_to be nil
          expect(league.active).to be false
        end
      end
    end

    describe 'if only one team has a game the following day' do
      before do
        league.winners.create(user: other_owner)
        league.winners.create(user: owner)
        league.end_today!
        create(:accomplishment, number: 2, team: team, date: Date.tomorrow)
      end

      it 'does not finalize the league' do
        travel_to Date.tomorrow do
          subject

          expect(league.winners_count).to eq(2)
          expect(league.confirmed_winners).to be_empty
          expect(league.end_date).not_to be nil
          expect(league.active).to be true
        end
      end
    end

    describe 'if there are three winners' do
      let(:third_ownership) { create(:ownership, league: league) }
      let(:third_team) { third_ownership.team }
      let(:third_owner) { third_ownership.user }
      let(:all_three_owners) { [owner, other_owner, third_owner] }
      let(:all_three_teams) { [team, other_team, third_team] }

      before do
        league.end_today!
        all_three_owners.each do |owner|
          league.winners.create(user: owner)
        end
      end

      describe 'and they are all tied' do
        before do
          all_three_teams.each do |team|
            create(:accomplishment, number: 15, team: team, date: Date.tomorrow)
          end
        end

        it 'should move the date forward and not deactivate the league' do
          travel_to 10.days.from_now do
            expect {
              subject
            }.to change { league.end_date }
            expect(league.winners_count).to eq(3)
            expect(league.confirmed_winners).to be_empty
            expect(league.active).to be(true)
          end
        end
      end

      describe 'two are tied and the third has a higher accomplishment' do
        before do
          [team, other_team].each do |team|
            create(:accomplishment, number: 15, team: team, date: Date.tomorrow)
          end
          create(:accomplishment, number: 16, team: third_team, date: Date.tomorrow)
        end

        it 'should end the league and declare a winner' do
          expect {
            subject
          }.to change { league.active }.to false
          expect(league.confirmed_winners).not_to be_empty
        end
      end

      describe 'two are tied and the third has a lower accomplishment' do
        before do
          [team, other_team].each do |team|
            create(:accomplishment, number: 15, team: team, date: Date.tomorrow)
          end
          create(:accomplishment, number: 14, team: third_team, date: Date.tomorrow)
        end

        it 'should remove a winner and move the league end_date forward' do
          travel_to Date.tomorrow do
            expect {
              subject
            }.to change { league.end_date }
            .and change { league.winners.count }.by(-1)
          end
        end
      end
    end
  end
end
