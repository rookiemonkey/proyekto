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
  end

  describe 'resource does\'nt exist' do
    before { delete organization_project_artifact_delete_path(project, 99_999) }

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end
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
  end
end
