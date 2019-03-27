require 'rails_helper'

describe Membership, type: :model do
  describe 'relationships' do
    it { should belong_to :league }
    it { should belong_to :user }
  end

  describe 'validations'
  describe 'methods'
end
