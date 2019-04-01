require 'rails_helper'

describe Accomplishment, type: :model do
  describe 'relationships' do
    it { should belong_to :team }
    it { should belong_to :game }
  end

  describe 'validations'
  describe 'methods'
end
