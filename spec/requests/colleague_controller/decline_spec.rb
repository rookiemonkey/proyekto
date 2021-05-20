require 'rails_helper'

RSpec.describe 'ColleagueController.decline', type: :request do
  let(:user) { create(:user) }
  let(:post_request) { post create_organization_colleague_path, params: { colleague: attributes_for(:user) } }
  let(:get_request) { get decline_organization_colleague_path, params: { invitation_id: User.last.invitation_id } }

  describe 'w/ auth' do
    before do
      sign_in(user)
      post_request
      get_request
    end

    it 'redirects to dashboard' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You are already logged in')
    end
  end

  describe 'GET /colleagues/decline' do
    before do
      sign_in(user)
      post_request
      sign_out(user)
    end

    it 'redirects to root' do
      get_request
      expect(response).to redirect_to(root_path)
    end

    it 'deletes the user from database' do
      expect { get_request }.to change(User, :count).by(-1)
    end

    it 'shows a success message' do
      get_request
      follow_redirect!
      expect(response.body).to include('Successfully declined the organization invitation!')
    end
  end

  describe 'invitation id that is not existing' do
    before { get decline_organization_colleague_path, params: { invitation_id: 'i-dont-exist-on-the-database' } }

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end
  end
end
