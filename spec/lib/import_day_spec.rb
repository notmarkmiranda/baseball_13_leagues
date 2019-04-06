require 'rails_helper'

describe ImportDay do
  let(:json_file) { file_fixture('04012019_master_scoreboard.json').read }
  let(:date) { Date.today }

  subject { described_class.lets_go!(date) }

  describe 'with a date object' do
    before { allow(ImportGame).to receive(:import!) }
    it 'should call the CreateGame class for games that are finished' do
      expect(BaseballService).to receive(:go!).with(date).and_return(json_file)
      subject

      expect(ImportGame).to have_received(:import!).exactly(9).times
    end
  end
end
