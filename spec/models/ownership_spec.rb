require 'rails_helper'

describe Ownership, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :league }
    it { should belong_to :team }
  end

  describe 'validations' do
    before { create(:ownership) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:league_id) }
    it { should validate_uniqueness_of(:team_id).scoped_to(:league_id) }
  end
  describe 'methods'
end
