require 'rails_helper'

RSpec.describe 'ArtifactController.delete', type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.first }
  let(:artifact) { project.artifacts.first }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
    create_list(:artifact, 10, project: project, organization: user.organization)
  end

  describe 'w/o auth' do
    let(:delete_request) { delete organization_project_artifact_delete_path(project, artifact) }

    before { sign_out(user) }

    it 'returns http redirect to login' do
      delete_request
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'doesn\'t delete the artifact' do
      expect { delete_request }.not_to change(Artifact, :count)
    end

    it 'shows an error message' do
      delete_request
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'DELETE /projects/:pid/artifacts/:aid' do
    let(:delete_request) { delete organization_project_artifact_delete_path(project, artifact) }

    it 'returns http redirect to fallback (dashboard)' do
      delete_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'deletes a single project' do
      expect { delete_request }.to change { Artifact.all.length }.by(-1)
    end

    it 'deletes the image on google cloud storage' do
      expect(Gcloud.get(artifact.image_name)).to eq(nil)
    end

    it 'shows a success message' do
      delete_request
      follow_redirect!
      expect(response.body).to include('Artifact successfully deleted!')
    end
  end

  describe 'resource does\'nt exist' do
    subject(:delete_request_fail) { delete organization_project_artifact_delete_path(project, 99_999) }

    it 'returns http redirect to fallback (dashboard)' do
      delete_request_fail
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      delete_request_fail
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end

    it 'doesn\'t delete the artifact' do
      expect { delete_request_fail }.not_to change(Artifact, :count)
    end
  end

  describe 'resource is disabled due to plan restrictions' do
    before do
      artifact.disabled = true
      artifact.save
      delete organization_project_artifact_delete_path(project, artifact)
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
