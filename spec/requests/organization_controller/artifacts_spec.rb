require 'rails_helper'

RSpec.describe 'OrganizationController.artifacts', type: :request do
  let(:user) { create(:user) }
  let(:organization) { user.organization }
  let(:projects) { organization.projects }

  before do
    sign_in(user)
    create_list(:project, 1, organization: organization)
    create_list(:artifact, 10) # not part of the user organization
    create_list(:artifact, 10, project: projects.first, organization: organization) # part of the user organization
  end

  describe 'w/o auth' do
    before do
      sign_out(:user)
      get orgazniation_artifacts_path
    end

    it 'returns http redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows an error' do
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing')
    end
  end

  describe 'GET /artifacts' do
    # for some reason, pagy returns an uninitialized error referring to params on backend.rb line:22
    # adding the page: 1 as an option fixes the issue but not needed anymore on the controller
    let(:artifacts) { pagy(Artifact.where(organization: user.organization), items: 30, page: 1)[1] }

    before { get orgazniation_artifacts_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders artifacts template' do
      expect(response).to render_template(:artifacts)
    end

    it 'has @artifacts instance variable scoped to current_tenant (organization)' do
      expect(assigns(:artifacts)).to eq(artifacts)
    end
  end
end
