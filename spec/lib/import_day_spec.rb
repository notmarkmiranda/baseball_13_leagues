require 'rails_helper'

describe ImportDay do
  let(:json_file) { file_fixture('04012019_master_scoreboard.json').read }
  let(:date) { Date.today }

  subject { described_class.lets_go!(date) }

  describe 'with a date object' do
    let!(:league) { create(:league) }

    before do
      allow(ImportGame).to receive(:import!)
      allow(Event).to receive(:create!)
      allow(WinnerChecker).to receive(:check_for_winner)
    end

    it 'should call the CreateGame class for games that are finished' do
      expect(BaseballService).to receive(:go!).with(date).and_return(json_file)
      subject

      expect(ImportGame).to have_received(:import!).exactly(9).times
      expect(Event).to have_received(:create!).with(event_type: 'ImportGame').once
      expect(WinnerChecker).to have_received(:check_for_winner).with(league).once
    end
  end
end
