class ProjectController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [:create]
  before_action :set_artifacts, only: [:read]

  def read
    render 'organization/project'
  end

  def create
    created_project = Project.create(project_params)
    raise ResourceError.new(message: get_error_for(created_project)) unless created_project.valid?

    redirect_to(organization_projects_path)
  end

  def update
    raise ResourceError.new(message: get_error_for(@project)) unless @project.update(project_params)

    redirect_back(fallback_location: organization_dashboard_path)
  end

  def delete
    @project.destroy
    redirect_back(fallback_location: organization_dashboard_path)
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def project_params_scoped
    scoped_params = project_params.to_hash
    scoped_params[:organization] = current_tenant
    scoped_params
  end
end
