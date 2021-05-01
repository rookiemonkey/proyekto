require 'rails_helper'

RSpec.describe OrganizationController, type: :request do
  let(:user) { create(:user) }
  let(:organization) { user.organization }

  before do
    sign_in(user)
    create_list(:project, 5) # not part of the user organization
    create_list(:artifact, 10) # not part of the user organization
    create_list(:project, 5, organization: organization) # part of the user organization
    create_list(:artifact, 10, project: organization.projects.first) # part of the user organization
  end

  describe 'GET /dashboard' do
    before { get organization_dashboard_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders dashboard template' do
      expect(response).to render_template(:dashboard)
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
      expect(assigns(:projects)).to eq(Project.where(organization: user.organization))
    end
  end

  describe 'GET /colleagues' do
    before { get orgazniation_colleagues_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders colleagues template' do
      expect(response).to render_template(:colleagues)
    end

    it 'has @colleagues instance variable scoped to current_tenant (organization)' do
      expect(assigns(:colleagues)).to eq(User.where(organization: user.organization))
    end
  end

  describe 'GET /artifacts' do
    before { get orgazniation_artifacts_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders artifacts template' do
      expect(response).to render_template(:artifacts)
    end

    it 'has @artifacts instance variable scoped to current_tenant (organization)' do
      expect(assigns(:artifacts)).to eq(Artifact.of(user.organization))
    end
  end
end
