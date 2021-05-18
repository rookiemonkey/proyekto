require 'rails_helper'

RSpec.describe 'ArtifactController.update', type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.first }
  let(:artifact) { project.artifacts.first }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
    create_list(:artifact, 10, project: project, organization: user.organization)
  end

  describe 'PUT /projects/:pid/artifacts/:aid' do
    let(:params) { { name: 'New Name', description: 'New Description' } }

    before do
      put organization_project_artifact_update_path(project, artifact), params: { artifact: params }
      artifact.reload
    end

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'updated the artifact name' do
      expect(artifact.name).to eq(params[:name])
    end

    it 'updated the artifact description' do
      expect(artifact.description).to eq(params[:description])
    end
  end

  describe 'resource does\'nt exist' do
    before { put organization_project_artifact_update_path(project, 99_999), params: { artifact: { name: nil } } }

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end
  end

  describe 'incorrect details (eg: name)' do
    before { put organization_project_artifact_update_path(project, artifact), params: { artifact: { name: nil } } }

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Name can&#39;t be blank')
    end
  end
end
