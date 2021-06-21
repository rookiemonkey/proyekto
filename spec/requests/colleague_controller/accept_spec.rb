require 'rails_helper'

RSpec.describe 'ColleagueController.accept', type: :request do
  let(:user) { create(:user) }
  let(:params) { { invite_new_password: '123456789', invite_new_password_confirm: '123456789' } }
  let(:post_request) { post create_organization_colleague_path, params: { colleague: attributes_for(:user) } }
  let(:put_request) { put accept_organization_colleague_path, params: { colleague: params, invitation_id: User.last.invitation_id } }

  describe 'w/ auth' do
    before do
      sign_in(user)
      post_request
    end

    it 'redirects to dashboard' do
      put_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'doesn\'t create an staff activity' do
      expect { put_request }.not_to change(Activity, :count)
    end

    it 'shows an error' do
      put_request
      follow_redirect!
      expect(response.body).to include('You are already logged in')
    end
  end

  describe 'PUT /colleagues/new' do
    before do
      sign_in(user)
      post_request
      sign_out(user)
    end

    it 'returns http redirect to login' do
      put_request
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'updates the invitation_id to nil' do
      put_request
      expect(User.last.invitation_id).to eq(nil)
    end

    it 'updates the password' do
      put_request
      expect(User.last.valid_password?(params[:invite_new_password])).to eq(true)
    end

    it 'creates a staff activity' do
      expect { put_request }.to change(Activity, :count).by(1)
    end

    it 'shows a success message' do
      put_request
      follow_redirect!
      expect(response.body).to include('Successfully created your account! Please login to continue')
    end
  end

  describe 'invitation id that is not existing' do
    before { put accept_organization_colleague_path, params: { colleague: params, invitation_id: 'i-dont-exist-on-the-database' } }

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end
  end

  describe 'incorrect details (eg: short password)' do
    let(:params) { { invite_new_password: '123', invite_new_password_confirm: '123' } }

    before do
      sign_in(user)
      post_request
      sign_out(user)
      put accept_organization_colleague_path, params: { colleague: params, invitation_id: User.last.invitation_id }
    end

    it 'returns http redirect to password change form' do
      expect(response).to redirect_to(create_organization_colleague_path(invitation_id: User.last.invitation_id))
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('Password is too short (minimum is 6 characters)')
    end
  end

  describe 'incorrect details (eg: password doesn\t match)' do
    let(:params) { { invite_new_password: '123456789', invite_new_password_confirm: 'abcdefghi' } }

    before do
      sign_in(user)
      post_request
      sign_out(user)
      put accept_organization_colleague_path, params: { colleague: params, invitation_id: User.last.invitation_id }
    end

    it 'returns http redirect to password change form' do
      expect(response).to redirect_to(create_organization_colleague_path(invitation_id: User.last.invitation_id))
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('Password does&#39;nt match')
    end
  end
end
