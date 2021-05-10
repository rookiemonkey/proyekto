require 'rails_helper'

RSpec.describe ColleagueController, type: :request do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'POST /colleagues/new' do
    let(:params) { attributes_for(:user) }
    let(:post_request) { post new_organization_colleague_path, params: { colleague: params } }

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
end
