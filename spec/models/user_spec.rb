require 'rails_helper'

describe User, type: :model do
  describe 'relationships' do
    it { should have_many :leagues }
  end

  describe 'validations'
  describe 'methods'
end
