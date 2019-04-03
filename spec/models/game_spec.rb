require 'rails_helper'

describe Game, type: :model do
  describe 'relationships' do
    it { should belong_to :home_team }
    it { should belong_to :away_team }
    it { should have_many :accomplishments }
  end

  describe 'validations' do
    before { create(:game) }

    it { should validate_presence_of :home_team_id }
    it { should validate_presence_of :away_team_id }
    it { should validate_presence_of :mlb_game_id }
  end

  describe 'methods'
end
