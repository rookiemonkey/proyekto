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

  describe 'w/o auth' do
    let(:params) { { name: 'New Name', description: 'New Description' } }
    let(:put_request) { put organization_project_artifact_update_path(project, artifact), params: { artifact: params } }

    before { sign_out(user) }

    it 'returns http redirect to login' do
      put_request
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      put_request
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end

    it 'doesn\'t update the artifact attributes' do
      artifact.reload
      expect(artifact.name).not_to eq(params[:name])
    end

    it 'doesn\'t create an artifact activity' do
      expect { put_request }.not_to change(Activity, :count)
    end
  end

  describe 'PUT /projects/:pid/artifacts/:aid' do
    let(:params) { { name: 'New Name', description: 'New Description' } }
    let(:put_request) { put organization_project_artifact_update_path(project, artifact), params: { artifact: params } }

    it 'returns http redirect to fallback (dashboard)' do
      put_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'updated the artifact name' do
      put_request
      artifact.reload
      expect(artifact.name).to eq(params[:name])
    end

    it 'updated the artifact description' do
      put_request
      artifact.reload
      expect(artifact.description).to eq(params[:description])
    end

    it 'creates an artifact activity' do
      expect { put_request }.to change(Activity, :count).by(1)
    end

    it 'shows a success message' do
      put_request
      follow_redirect!
      expect(response.body).to include('Artifact successfully updated!')
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

    it 'doesn\'t update the artifact attributes' do
      artifact.reload
      expect(artifact.name).not_to eq(nil)
    end
  end

  describe 'resource is disabled due to plan restrictions' do
    before do
      artifact.disabled = true
      artifact.save
      put organization_project_artifact_update_path(project, artifact), params: { artifact: { name: 'New Name!' } }
    end

    it 'returns http redirect to projects' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource is disabled due to plan restrictions. Please upgrade your plan to regain access')
    end
  end
end
