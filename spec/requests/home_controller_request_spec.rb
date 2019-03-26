require 'rails_helper'

describe HomeController, type: :request do
  describe 'GET#index' do
    subject { get root_path }

    before { subject }

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end
  end
end
