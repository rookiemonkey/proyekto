require 'rails_helper'

RSpec.describe 'ProjectController.create', type: :request do
  let(:user) { create(:user) }
  let(:project) { user.organization.projects.sample }
  let(:params) { { project: { name: 'New Name' } } }
  let(:put_request) { put organization_project_update_path(project), params: params }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
  end

  describe 'w/o auth' do
    before do
      sign_out(:user)
      put_request
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end

    it 'doesn\'t update the project attributes' do
      project.reload
      expect(project.name).not_to eq(params[:name])
    end
  end

  describe 'PUT /projects/:id' do
    before do
      put_request
      project.reload
    end

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'updates the project name' do
      expect(project.name).to eq(params[:project][:name])
    end

    it 'shows a success message' do
      follow_redirect!
      expect(response.body).to include('Project successfully updated!')
    end
  end

  describe 'incorrect details (eg: name)' do
    before { put organization_project_update_path(user.organization.projects.sample), params: { project: { name: nil } } }

    it 'returns http redirect to fallback (dashboard)' do
      expect(response).to redirect_to(organization_dashboard_path)
    end

    it 'shows an error message' do
      follow_redirect!
      expect(response.body).to include('Name can&#39;t be blank')
    end

    it 'doesn\'t update the project attributes' do
      project.reload
      expect(project.name).not_to eq(params[:name])
    end
  end
end
