require 'rails_helper'

RSpec.describe 'ColleagueController.new', type: :request do
  let(:user) { create(:user) }
  let(:post_request) { post create_organization_colleague_path, params: { colleague: attributes_for(:user) } }

  describe 'w/ auth' do
    subject(:get_request) { get new_organization_colleague_path, params: { invitation_id: User.last.invitation_id } }

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

  describe 'GET /colleagues/new' do
    subject(:get_request) { get new_organization_colleague_path, params: { invitation_id: User.last.invitation_id } }

    before do
      sign_in(user)
      post_request
      sign_out(user)
      get_request
    end

    it 'returns https success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders new_colleague template' do
      expect(response).to render_template(:new_colleague)
    end

    it 'renders the landing layout' do
      expect(get_request).to render_template('layouts/landing')
    end
  end

  describe 'invitation id that is not existing' do
    before { get new_organization_colleague_path, params: { invitation_id: 'i-dont-exist-in-the-database' } }

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end
  end
end
