require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  describe 'GET /users/signup' do
    subject(:sign_up_form) { get new_user_registration_path }

    it 'uses the landing layout' do
      expect(sign_up_form).to render_template('layouts/landing')
    end
  end

  describe 'POST /users/signup (new user && org)' do
    let(:post_request) do
      post user_registration_path, params: { user: { **attributes_for(:user), organization: 'Test Organization' } }
    end

    it 'redirects to dashboard' do
      post_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'creates a single user' do
      expect { post_request }.to change { User.all.length }.by(1)
    end

    it 'creates a single organization' do
      expect { post_request }.to change { Organization.all.length }.by(1)
    end
  end

  describe 'POST /users/signup (new user && existing org)' do
    let(:post_request) do
      post user_registration_path, params: { user: { **attributes_for(:user), organization: 'New Organization' } }
    end

    before { create(:organization, name: 'New Organization') }

    it 'redirects to dashboard' do
      post_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'creates a single user' do
      expect { post_request }.to change { User.all.length }.by(1)
    end

    it 'does not have any changes with the organization table' do
      expect { post_request }.not_to(change { Organization.all.length })
    end
  end
end
