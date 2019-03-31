require 'rails_helper'

describe OwnershipsController, type: :request do
  let(:league) { create(:league) }
  let(:admin) { league.user }
  let(:membership) { create(:membership, league: league, role: 0) }
  let(:user) { membership.user }

  describe 'GET#new' do
    subject { get new_league_ownership_path(league)}

    describe 'As an admin' do
      before { sign_in(admin) }

      it 'renders - 200' do
        subject

        expect(response).to have_http_status(200)
      end
    end

    describe 'As a user' do
      before { sign_in(user) }
      it 'redirects - 302' do
        expect {
          subject
        }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe 'POST#create'
end
