require 'rails_helper'

describe DashboardController, type: :request do
  describe 'GET#show' do
    subject { get dashboard_path }

    describe 'as a user' do
      let(:user) { create(:user, role: 0) }

      before { sign_in(user) }
      it 'should render - 200' do
        subject

        expect(response).to have_http_status(200)
      end
    end

    describe 'as a visitor' do
      it 'should redirect - 302' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end
end
