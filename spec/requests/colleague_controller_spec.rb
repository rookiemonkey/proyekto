require 'rails_helper'

RSpec.describe ColleagueController, type: :request do
  let(:user) { create(:user) }
  let(:post_request) { post new_organization_colleague_path, params: { colleague: attributes_for(:user) } }

  before { sign_in(user) }

  describe 'POST /colleagues/new' do
    it 'returns http success' do
      post_request
      expect(response).to have_http_status(:success)
    end

    it 'creates a single user' do
      expect { post_request }.to change(User, :count).by(1)
    end

    it 'creates a single user w/ inviation id' do
      post_request
      expect(User.last.invitation_id.nil?).to eq(false)
    end
  end

  describe 'PUT /colleagues/new' do
    let(:params) { { invite_new_password: '123456789', invite_new_password_confirm: '123456789' } }

    before do
      post_request
      put accept_organization_colleague_path, params: { colleague: { **params, invitation_id: User.last.invitation_id } }
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'updates the invitation_id to nil' do
      expect(User.last.invitation_id).to eq(nil)
    end

    it 'updates the password' do
      expect(User.last.valid_password?(params[:invite_new_password])).to eq(true)
    end
  end
end
