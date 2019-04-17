require 'rails_helper'

describe 'Admin can mark an owner' do
  let(:league) { create(:league) }
  let(:admin) { league.user }
  let(:team) { create(:team) }
  let!(:ownership) { create(:ownership, league: league, team: team) }

  before { login_as(admin, scope: :user) }

  describe 'as paid if they are unpaid' do
    it 'should mark the owner as paid and not show a paid button' do
      visit league_path(league)

      find(:css, 'button.mark-as-button.mark-as-paid-button').click

      expect(page).to have_css('button.mark-as-button.mark-as-unpaid-button')
      expect(page).not_to have_css('button.mark-as-button.mark-as-paid-button')
    end
  end

  describe 'as unpaid if they are paid' do
    before { ownership.update(paid: true) }

    it 'should mark the owner as unpaid and not show an unpaid button' do
      visit league_path(league)

      find(:css, 'button.mark-as-button.mark-as-unpaid-button').click

      expect(page).to have_css('button.mark-as-button.mark-as-paid-button')
      expect(page).not_to have_css('button.mark-as-button.mark-as-unpaid-button')
    end
  end
end
