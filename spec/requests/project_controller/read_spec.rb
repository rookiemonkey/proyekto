require 'rails_helper'

RSpec.describe 'ProjectController.read', type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.sample }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
    create_list(:artifact, 5, project: project, organization: user.organization)
  end

  describe 'w/o auth' do
    before do
      sign_out(:user)
      get organization_project_path(project)
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'GET /projects/:id' do
    before { get organization_project_path(project) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders project template' do
      expect(response).to render_template(:project)
    end

    it 'has @project instance variable' do
      expect(assigns(:project)).to eq(project)
    end

    it 'has @artifacts instance variable' do
      expect(assigns(:artifacts)).to eq(project.artifacts)
    end
  end

  describe 'resource does\'nt exist' do
    before { get organization_project_path(99_999) }

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end
  end

  describe 'resource is disabled due to plan restrictions' do
    before do
      project.disabled = true
      project.save
      get organization_project_path(project)
    end

    it 'returns http redirect to projects' do
      expect(response).to redirect_to(organization_projects_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource is disabled due to plan restrictions. Please upgrade your plan to regain access')
    end
  end
end
