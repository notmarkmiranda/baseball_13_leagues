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

  describe 'when there are two winners' do
    let(:other_ownership) { create(:ownership, league: league) }
    let(:other_team) { other_ownership.team }

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

      expect(league.active).to be false
      expect(league.end_date).not_to be nil
    end
  end
end
