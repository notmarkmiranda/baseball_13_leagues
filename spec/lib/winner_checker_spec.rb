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

  describe 'when there are 2 winners' do
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

  end
end
