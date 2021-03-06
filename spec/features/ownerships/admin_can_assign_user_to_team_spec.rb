require 'rails_helper'

describe 'Admin user can assign a user to a team' do
  let(:league) { create(:league) }
  let(:admin) { league.user }
  let!(:team) { create(:team) }
  let(:user) { create(:user) }

  describe 'as an admin' do
    before { login_as(admin, scope: :user) }

    describe 'an existing user' do
      let(:user) { create(:user) }


      it 'assigns the existing user to the team' do
        visit league_path(league)

        click_link 'Assign Team'
        fill_in 'User Email', with: user.email
        click_button 'Assign!'

        expect(current_path).to eq(league_path(league))
        expect(page).to have_content(team.name)
        expect(page).to have_content(user.email)
      end

      it 'does not assign the existing user if the team is taken' do
        create(:ownership, league: league, team: team)

        visit league_path(league)

        expect(page).to have_content('Dashboard')
        expect(page).not_to have_link('Assign Team')
      end
    end

    describe 'a new user' do
      let(:new_user_email) { 'superduper@fakeuser.com' }

      it 'assigns the new user to the team' do
        visit league_path(league)

        click_link 'Assign Team'
        fill_in 'User Email', with: new_user_email
        click_button 'Assign!'

        expect(current_path).to eq(league_path(league))
        expect(page).to have_content(team.name)
        expect(page).to have_content(new_user_email)
      end
    end

    describe 'itself' do
      it 'assigns the admin to the team' do
        visit league_path(league)

        click_link 'Assign Team'
        fill_in 'User Email', with: admin.email
        click_button 'Assign!'

        expect(current_path).to eq(league_path(league))
        expect(page).to have_content(team.name)
        expect(page).to have_content(admin.email)
      end
    end
  end

  describe 'as a user' do
    before { login_as(user, scope: :user) }

    it 'does not show the user any links to try to assign teams' do
      visit league_path(league)

      expect(page).to have_content(team.name)
      expect(page).not_to have_link('Assign Team')
    end
  end
end
