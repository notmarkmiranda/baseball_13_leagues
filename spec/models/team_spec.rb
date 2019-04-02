require 'rails_helper'

describe Team, type: :model do
  describe 'relationships' do
    it { should have_many :home_games }
    it { should have_many :away_games }
    it { should have_many :ownerships }
    it { should have_many :accomplishments }
  end

  describe 'validations'
  describe 'methods'
end
