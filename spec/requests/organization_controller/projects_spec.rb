require 'rails_helper'

RSpec.describe 'OrganizationController.projects', type: :request do
  let(:user) { create(:user) }
  let(:organization) { user.organization }

  before do
    sign_in(user)
    create_list(:project, 5) # not part of the user organization
    create_list(:project, 5, organization: organization) # part of the user organization
  end

  describe 'w/o auth' do
    before do
      sign_out(:user)
      get organization_projects_path
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'GET /projects' do
    before { get organization_projects_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders projects template' do
      expect(response).to render_template(:projects)
    end

    it 'has @projects instance variable scoped to current_tenant (organization)' do
      database_projects = Project.where(organization: user.organization)

      is_content_match = assigns(:projects).all? do |project|
        database_projects.any? { |database_project| database_project.id == project.id }
      end

      expect(is_content_match).to eq(true)
    end
  end
end
