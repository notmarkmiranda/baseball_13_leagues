require 'rails_helper'

describe OwnershipsController, type: :request do
  let(:league) { create(:league) }
  let(:admin) { league.user }
  describe 'GET#new' do
    subject { get new_league_ownership_path(league)}

    describe 'As an admin' do
      before { sign_in(admin) }

      it 'renders the new template' do
        subject

        expect(response).to have_http_status(200)
      end
    end

    describe 'As a user'
  end

  describe 'POST#create'
end
