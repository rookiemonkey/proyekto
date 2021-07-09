require 'rails_helper'

RSpec.describe 'OrganizationController.dashboard', type: :request do
  let(:user) { create(:user) }
  let(:organization) { user.organization }
  let(:projects) { organization.projects }
  let(:get_request) { get organization_dashboard_path }

  before do
    sign_in(user)

    # project, artifacts, and users not part of the user organization
    create_list(:user, 5)
    create_list(:project, 5)
    create_list(:artifact, 10)

    # project, artifacts, and users part of the user organization
    create_list(:user, 2, organization: organization)
    create_list(:project, 5, organization: organization)
    create_list(:artifact, 10, project: projects.first, organization: organization)
  end

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

    it 'has @num_of_projects instance variable scoped to current_tenant (organization)' do
      expect(assigns(:num_of_projects)).to eq(Project.where(organization: user.organization).count)
    end

    it 'has @num_of_artifacts instance variable scoped to current_tenant (organization)' do
      expect(assigns(:num_of_artifacts)).to eq(Artifact.where(organization: user.organization).count)
    end

    it 'has @num_of_staffs instance variable scoped to current_tenant (organization)' do
      expect(assigns(:num_of_staffs)).to eq(User.where(organization: user.organization).count)
    end
  end
end
