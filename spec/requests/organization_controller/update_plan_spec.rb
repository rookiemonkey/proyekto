require 'rails_helper'

RSpec.describe 'OrganizationController.update_plan', type: :request do
  let(:user) { create(:user) }
  let(:organization) { user.organization }

  before do
    sign_in(user)
  end

  describe 'w/o auth' do
    before do
      sign_out(:user)
      put update_organization_plan_path, params: { plan: { new_plan: 'standard' } }
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'PUT /plans' do
    let(:put_request) { put update_organization_plan_path, params: { plan: { plan: 'standard' } } }

    it 'updates the organization plan' do
      put_request
      organization.reload
      expect(organization.plan).to eq('standard')
    end

    it 'returns a hash with success key' do
      put_request
      expect(JSON.parse(response.body).key?('success')).to eq(true)
    end

    it 'returns a hash with message key' do
      put_request
      expect(JSON.parse(response.body).key?('message')).to eq(true)
    end

    it 'creates an account activity' do
      expect { put_request }.to change(Activity, :count).by(1)
    end

    it 'shows success is true' do
      put_request
      expect(JSON.parse(response.body).fetch('success')).to eq(true)
    end

    it 'shows message is succesful' do
      put_request
      expect(JSON.parse(response.body).fetch('message')).to eq('Successfully updated your plan')
    end
  end
end
