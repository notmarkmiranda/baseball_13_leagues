require 'rails_helper'

describe User, type: :model do
  let(:user) { create(:user) }
  describe 'relationships' do
    it { should have_many :leagues }
    it { should have_many :memberships }
  end

  describe 'validations'
  describe 'methods' do
    describe '#membered_or_admined_leagues' do
      let!(:member_league) { create(:membership, user: user, role: 0).league }
      let!(:admin_league) { create(:membership, user: user, role: 1).league }
      let!(:other_league) { create(:membership).league }

      subject { user.membered_or_admined_leagues }

      it 'returns leagues the user is an admin or member of' do
        expect(subject).to include(member_league)
        expect(subject).to include(admin_league)
        expect(subject).not_to include(other_league)
      end
    end
  end
end
