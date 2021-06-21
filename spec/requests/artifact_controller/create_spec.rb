require 'rails_helper'

RSpec.describe 'ArtifactController.create', type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.first }
  let(:artifact) { project.artifacts.first }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
    create_list(:artifact, 10, project: project, organization: user.organization)
  end

  describe 'w/o auth' do
    let(:post_request) { post new_organization_project_artifact_path(project), params: { artifact: attributes_for(:artifact) } }

    before { sign_out(user) }

    it 'returns http redirect to login' do
      post_request
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'doesn\'t create a new artifact' do
      expect { post_request }.not_to change(Artifact, :count)
    end

    it 'doesn\'t create an artifact activity' do
      expect { post_request }.not_to change(Activity, :count)
    end

    it 'shows an error message' do
      post_request
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'POST /projects/:pid/artifacts/new' do
    let(:post_request) { post new_organization_project_artifact_path(project), params: { artifact: attributes_for(:artifact) } }

    it 'returns http redirect to fallback (dashboard)' do
      post_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'creates a single artifact' do
      expect { post_request }.to change(Artifact, :count).by(1)
    end

    it 'creates an artifact activity' do
      expect { post_request }.to change(Activity, :count).by(1)
    end

    it 'shows a success message' do
      post_request
      follow_redirect!
      expect(response.body).to include('Artifact successfully created!')
    end
  end

  describe 'incorrect details (eg: name)' do
    let(:params) { attributes_for(:artifact) }
    let(:post_request) { post new_organization_project_artifact_path(project), params: { artifact: { **params, name: nil } } }

    it 'returns http redirect to fallback (dashboard)' do
      post_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      post_request
      follow_redirect!
      expect(response.body).to include('Name can&#39;t be blank')
    end

    it 'does\'nt create an artifact' do
      expect { post_request }.not_to change(Artifact, :count)
    end
  end

  describe 'upload with big images' do
    let(:post_request) do
      post(
        new_organization_project_artifact_path(project),
        params: {
          artifact: {
            **attributes_for(:artifact),
            image: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/morethan_1mb.jpg'), 'image/jpeg')
          }
        }
      )
    end

    it 'shows an error that file is too big' do
      post_request
      follow_redirect!
      expect(response.body).to include('File is too big')
    end

    it 'does\'nt create an artifact' do
      expect { post_request }.not_to change(Artifact, :count)
    end
  end

  describe 'upload with non-images' do
    let(:post_request) do
      post(
        new_organization_project_artifact_path(project),
        params: {
          artifact: {
            **attributes_for(:artifact),
            image: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/im_not_an_image.png'), 'image/png')
          }
        }
      )
    end

    it 'shows an error that file not an image' do
      post_request
      follow_redirect!
      expect(response.body).to include('File is not an image')
    end

    it 'does\'nt create an artifact' do
      expect { post_request }.not_to change(Artifact, :count)
    end
  end
end
