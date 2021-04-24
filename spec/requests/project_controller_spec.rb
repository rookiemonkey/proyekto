require 'rails_helper'

RSpec.describe ProjectController, type: :request do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    create_list(:project, 5, organization: user.organization)
  end

  describe 'GET /projects/:id' do
    let(:project) { user.organization.projects.sample }

    before { get organization_project_path(project) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders project template' do
      expect(response).to render_template(:project)
    end

    it 'has @project instance variable' do
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST /projects/new' do
    let(:post_request) { post new_organization_project_path, params: { project: attributes_for(:project) } }

    it 'returns http success' do
      post_request
      expect(response).to have_http_status(:success)
    end

    it 'creates a single project' do
      expect { post_request }.to change { Project.all.length }.by(1)
    end
  end

  describe 'PUT /projects/:id' do
    let(:project) { user.organization.projects.sample }
    let(:params) { { project: { name: 'New Name' } }  }

    before { put organization_project_update_path(project), params: params }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'updates the project name' do
      project.reload
      expect(project.name).to eq(params[:project][:name])
    end
  end

  describe 'DELETE /projects/:id' do
    let(:project) { user.organization.projects.sample }
    let(:delete_request) { delete organization_project_delete_path(project) }

    it 'returns http success' do
      delete_request
      expect(response).to have_http_status(:success)
    end

    it 'deletes a single project' do
      expect { delete_request }.to change { Project.all.length }.by(-1)
    end
  end
end