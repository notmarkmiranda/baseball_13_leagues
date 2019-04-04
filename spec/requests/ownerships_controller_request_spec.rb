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

  describe 'POST#create' do
    subject { post league_ownerships_path(league), params: { ownership: ownership_params } }

    let(:team) { create(:team) }
    let(:ownership_params) { attributes_for(:ownership).merge(user: { email: owner_email }, team_id: team.id) }

    before { sign_in(admin) }
    describe 'for a new user' do
      let(:owner_email) { 'test@example.com' }

      it 'should create a new user and a new ownership' do
        expect {
          subject
        }.to change(User, :count).by(1)
        .and change(Ownership, :count).by(1)
        .and change(Membership, :count).by(1)
        expect(response).to have_http_status(302)
      end
    end

    describe 'for an existing user' do
      let!(:user) { create(:user) }
      let(:owner_email) { user.email }

      it 'should only create a new ownership and not a new user' do
        expect {
          subject
        }.to change(User, :count).by(0)
        .and change(Ownership, :count).by(1)
        .and change(Membership, :count).by(1)
        expect(response).to have_http_status(302)
      end
    end

    describe 'for the existing member' do
      let!(:user) { create(:membership, league: league).user }
      let(:owner_email) { user.email }

      it 'should only create a new ownership and not a new membership' do
        expect {
          subject
        }.to change(User, :count).by(0)
        .and change(Ownership, :count).by(1)
        .and change(Membership, :count).by(0)
        expect(response).to have_http_status(302)
      end
    end

    describe 'for logged in user' do
      let(:owner_email) { admin.email }

      it 'should create an ownership only' do
        expect {
          subject
        }.to change(User, :count).by(0)
        .and change(Ownership, :count).by(1)
        .and change(Membership, :count).by(0)
        expect(response).to have_http_status(302)
      end
    end

    describe 'for user with a team already' do
      let(:new_team) { create(:team) }
      let!(:user) { create(:ownership, team: new_team, league: league).user }
      let(:owner_email) { user.email }

      it 'does not create anything' do
        expect {
          subject
        }.to change(User, :count).by(0)
        .and change(Ownership, :count).by(0)
        .and change(Membership, :count).by(0)
      end
    end
  end
end
