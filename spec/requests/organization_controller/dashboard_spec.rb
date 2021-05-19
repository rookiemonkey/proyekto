require 'rails_helper'

RSpec.describe 'OrganizationController.dashboard', type: :request do
  let(:user) { create(:user) }
  let(:organization) { user.organization }
  let(:get_request) { get organization_dashboard_path }

  before { sign_in(user) }

  describe 'w/o auth' do
    before do
      sign_out(:user)
      get_request
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'GET /dashboard' do
    before { get_request }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders dashboard template' do
      expect(response).to render_template(:dashboard)
    end
  end
end
