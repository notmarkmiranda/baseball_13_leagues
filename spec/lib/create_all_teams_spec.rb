require 'rails_helper'

describe CreateAllTeams do
  describe 'self#lets_go!' do
    let(:team_double) { instance_double('Team', name: 'team_name') }
    subject { described_class.lets_go! }

    before { allow(Team).to receive(:find_or_create_by).and_return(team_double) }

    it 'should call #find_or_create_by 30 times' do
      subject

      expect(Team).to have_received(:find_or_create_by).exactly(30).times
    end
  end
end
