require 'rails_helper'

describe ImportDay do
  let(:json_file) { file_fixture('04012019_master_scoreboard.json').read }

  subject { described_class.new(json_file).import! }

  before { allow(ImportGame).to receive(:import!) }
  it 'should call the CreateGame class for games that are finished' do
    subject
    
    expect(ImportGame).to have_received(:import!).exactly(9).times
  end
end
