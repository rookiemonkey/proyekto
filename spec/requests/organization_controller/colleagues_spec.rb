require 'rails_helper'

RSpec.describe 'OrganizationController.colleagues', type: :request do
  let(:user) { create(:user) }
  let(:organization) { user.organization }

  before do
    sign_in(user)
    create_list(:project, 5) # not part of the user organization
    create_list(:project, 5, organization: organization) # part of the user organization
  end

  describe 'w/o auth' do
    before do
      sign_out(:user)
      get orgazniation_colleagues_path
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'GET /colleagues' do
    before { get orgazniation_colleagues_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders colleagues template' do
      expect(response).to render_template(:colleagues)
    end

    it 'has @colleagues instance variable scoped to current_tenant (organization)' do
      expect(assigns(:colleagues)).to eq(User.where(organization: user.organization))
    end
  end
end
