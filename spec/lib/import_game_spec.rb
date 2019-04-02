require 'rails_helper'

describe ImportGame do
  let(:json_file) { file_fixture('04012019_finished_game.json').read }
  let(:game_json) { JSON.parse(json_file).with_indifferent_access }
  let(:game_date) { Date.new(2019, 4, 1) }

  describe 'self#import!' do
    subject { described_class.import!(game_json, game_date)}

    it 'should create a game and 2 accomplishments' do
      expect {
        subject
      }.to change(Game, :count).by(1)
      .and change(Accomplishment, :count).by(2)
    end
  end
end
