require 'rails_helper'

describe League, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :memberships }
    it { should have_many :ownerships }
    it { should have_many :winners }
  end

  describe 'validations' do
    before { create(:league) }

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :start_date }
  end

  describe 'methods' do
    describe 'after_create#create_admin' do
      let(:league) { build(:league) }

      it 'should create a league and an admin for that league' do
        expect {
          league.save
        }.to change(League, :count).by(1)
        .and change(Membership, :count).by(1)
      end
    end
  end
end
