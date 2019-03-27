require 'rails_helper'

describe 'Admin user can create a league', type: :feature do
  let(:admin) { create(:user, role: 1) }
  let(:user) { create(:user, role: 0) }

  describe 'as an admin user' do
    let(:league_name) { 'Super Duper!' }

    before { login_as(admin, scope: :user) }

    it 'should allow the admin to create a league' do
      visit dashboard_path

      click_link 'Create League'
      fill_in 'League Name', with: league_name
      fill_in 'Start Date', with: '05/09/2015'
      click_button 'Vamonos!'

      expect(page).to have_content(league_name)
    end
  end

  describe 'as a user' do
    before { login_as(user, scope: :user) }

    it 'should not show the use the link for create league' do
      visit dashboard_path

      expect(page).to have_content('dashboard')
      expect(page).not_to have_link('Create League')
    end
  end
end
