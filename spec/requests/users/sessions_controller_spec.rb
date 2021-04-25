require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe 'GET /users/signin' do
    subject(:sign_in_form) { get new_user_session_path }

    it 'uses the landing layout' do
      expect(sign_in_form).to render_template('layouts/landing')
    end
  end

  describe 'POST /users/sigin' do
    before { post user_session_path, params: { user: { email: user.email, password: '987654321' } } }

    it 'redirects to dashboard' do
      expect(response).to redirect_to(organization_dashboard_path)
    end
  end
end
