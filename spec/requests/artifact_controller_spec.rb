require 'rails_helper'

RSpec.describe ArtifactController, type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.first }
  let(:artifact) { project.artifacts.first }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
    create_list(:artifact, 10, project: project)
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

  describe 'GET /projects/:pid/artifacts/:aid' do
    before { get organization_project_artifact_path(project, artifact) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders artifact template' do
      expect(response).to render_template(:artifact)
    end

    it 'has @artifact instance variable' do
      expect(assigns(:artifact)).to eq(artifact)
    end
  end

  describe 'POST /projects/:pid/artifacts/new' do
    let(:post_request) { post new_organization_project_artifact_path(project), params: { artifact: attributes_for(:artifact) } }

    it 'returns http success' do
      post_request
      expect(response).to have_http_status(:success)
    end

    it 'creates a single artifact' do
      expect { post_request }.to change { Artifact.all.length }.by(1)
    end
  end

  describe 'PUT /projects/:pid/artifacts/:aid' do
    let(:params) { { name: 'New Name', description: 'New Description' } }

    before do
      put organization_project_artifact_update_path(project, artifact), params: { artifact: params }
      artifact.reload
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'updated the artifact name' do
      expect(artifact.name).to eq(params[:name])
    end

    it 'updated the artifact description' do
      expect(artifact.description).to eq(params[:description])
    end
  end

  describe 'DELETE /projects/:pid/artifacts/:aid' do
    let(:delete_request) { delete organization_project_artifact_delete_path(project, artifact) }

    it 'returns http success' do
      delete_request
      expect(response).to have_http_status(:success)
    end

    it 'deletes a single project' do
      expect { delete_request }.to change { Artifact.all.length }.by(-1)
    end
  end
end
