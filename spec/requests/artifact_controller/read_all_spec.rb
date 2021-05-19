require 'rails_helper'

RSpec.describe 'ArtifactController.read_all', type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.first }
  let(:artifact) { project.artifacts.first }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
    create_list(:artifact, 10, project: project, organization: user.organization)
  end

  describe 'w/o auth' do
    let(:get_request) { get organization_project_artifacts_path(project) }

    before { sign_out(user) }

    it 'returns http redirect to login' do
      get_request
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET /projects/:pid/artifacts' do
    before { get organization_project_artifacts_path(project) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders artifacts template' do
      expect(response).to render_template(:artifacts)
    end

    it 'has @artifacts instance variable' do
      expect(assigns(:artifacts)).to eq(project.artifacts)
    end
  end

  describe 'reaching last page' do
    before { get organization_project_artifacts_path(project), params: { page: 99_999 } }

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('You&#39;ve reached the last page')
    end
  end
end
