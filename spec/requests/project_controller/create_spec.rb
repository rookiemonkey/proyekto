require 'rails_helper'

RSpec.describe 'ProjectController.create', type: :request do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'w/o auth' do
    let(:post_request) { post new_organization_project_path, params: { project: attributes_for(:project) } }

    before do
      sign_out(:user)
    end

    it 'returns http redirect to login' do
      post_request
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'doesn\'t create a new project' do
      expect { post_request }.not_to change(Project, :count)
    end

    it 'doesn\'t create a project activity' do
      expect { post_request }.not_to change(Activity, :count)
    end

    it 'shows an error' do
      post_request
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'POST /projects/new' do
    let(:post_request) { post new_organization_project_path, params: { project: attributes_for(:project) } }

    it 'returns http redirect to /projects' do
      post_request
      expect(response).to redirect_to(organization_projects_path)
    end

    it 'creates a single project' do
      expect { post_request }.to change { Project.all.length }.by(1)
    end

    it 'creates a project activity' do
      expect { post_request }.to change(Activity, :count).by(1)
    end


    it 'shows a success message' do
      post_request
      follow_redirect!
      expect(response.body).to include('Project successfully created!')
    end
  end

  describe 'incorrect details (eg: name)' do
    let(:post_request) { post new_organization_project_path, params: { project: { name: nil } } }

    it 'returns http redirect to fallback (dashboard)' do
      post_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      post_request
      follow_redirect!
      expect(response.body).to include('Name can&#39;t be blank')
    end

    it 'does\'nt create a project' do
      expect { post_request }.not_to change(Project, :count)
    end
  end
end
