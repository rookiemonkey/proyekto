require 'rails_helper'

RSpec.describe 'ColleagueController.create', type: :request do
  let(:user) { create(:user) }
  let(:post_request) { post create_organization_colleague_path, params: { colleague: attributes_for(:user) } }

  before { sign_in(user) }

  describe 'w/o auth' do
    before do
      sign_out(:user)
      post_request
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'POST /colleagues/new' do
    it 'returns http redirect to fallback (dashboard)' do
      post_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'creates a single user' do
      expect { post_request }.to change(User, :count).by(1)
    end

    it 'creates a single user w/ inviation id' do
      post_request
      expect(User.last.invitation_id.nil?).to eq(false)
    end

    it 'shows a success message' do
      post_request
      follow_redirect!
      expect(response.body).to include('Invitation Email successfully sent to colleague!')
    end
  end

  describe 'incorrect details (eg: full_name)' do
    let(:params) { { full_name: nil, email: Faker::Internet.unique.safe_email } }
    let(:post_request_fail) { post create_organization_colleague_path, params: { colleague: params } }

    it 'returns http redirect to fallback (dashboard)' do
      post_request_fail
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      post_request_fail
      follow_redirect!
      expect(response.body).to include('Full name can&#39;t be blank')
    end

    it 'does\'nt create a user' do
      expect { post_request_fail }.not_to change(User, :count)
    end
  end
end
