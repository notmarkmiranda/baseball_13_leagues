require 'rails_helper'

describe LeaguesController, type: :request do
  let(:admin) { create(:user, role: 1) }
  let(:user) { create(:user, role: 0) }

  describe 'GET#show' do
    subject { get league_path(league) }
  end

  describe 'GET#new' do
    subject { get new_league_path }

    describe 'as an admin' do
      before { sign_in(admin) }

      it 'should render - 200' do
        subject

        expect(response).to have_http_status(200)
      end
    end

    describe 'as a user' do
      before { sign_in(user) }

      it 'should redirect - 302' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST#create' do
    let(:league_params) { { league: attributes_for(:league) } }
    let(:bad_league_params) { { league: attributes_for(:league).except(:start_date) } }

    subject { post leagues_path, params: params }

    describe 'as an admin' do
      before { sign_in(admin) }

      describe 'with good params' do
        let(:params) { league_params }

        it 'should change count and redirect - 302' do
          expect {
            subject
          }.to change(League, :count).by(1)
          expect(response).to have_http_status(302)
        end
      end

      describe 'with bad params' do
        let(:params) { bad_league_params }

        it 'should not change count and render - 200' do
          expect {
            subject
          }.not_to change(League, :count)
          expect(response).to have_http_status(200)
        end
      end
    end

    describe 'as a user' do
      let(:params) { league_params }

      before { sign_in(user) }

      it 'should not change count and redirect - 302' do
        expect {
          subject
        }.not_to change(League, :count)
        expect(response).to have_http_status(302)
      end
    end
  end
end
