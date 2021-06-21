require 'rails_helper'

RSpec.describe 'ProjectController.delete', type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.sample }
  let(:delete_request) { delete organization_project_delete_path(project) }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
  end

  describe 'w/o auth' do
    before do
      sign_out(:user)
    end

    it 'returns http redirect to login' do
      delete_request
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'doesn\'t delete the project' do
      expect { delete_request }.not_to change(Project, :count)
    end


    it 'doesn\'t create an artifact activity' do
      expect { delete_request }.not_to change(Activity, :count)
    end

    it 'shows an error' do
      delete_request
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'DELETE /projects/:id' do
    it 'returns http redirect to fallback (dashboard)' do
      delete_request
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'deletes a single project' do
      expect { delete_request }.to change { Project.all.length }.by(-1)
    end

    it 'creates a project activity' do
      expect { delete_request }.to change(Activity, :count).by(1)
    end

    it 'shows a success message' do
      delete_request
      follow_redirect!
      expect(response.body).to include('Project successfully deleted!')
    end
  end

  describe 'resource does\'nt exist' do
    subject(:delete_request_fail) { delete organization_project_delete_path(99_999) }

    it 'returns http redirect to fallback (dashboard)' do
      delete_request_fail
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      delete_request_fail
      follow_redirect!
      expect(response.body).to include('Resource not found')
    end

    it 'doesn\'t delete the project' do
      expect { delete_request_fail }.not_to change(Project, :count)
    end
  end

  describe 'resource is disabled due to plan restrictions' do
    before do
      project.disabled = true
      project.save
      delete organization_project_delete_path(project)
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
