class ProjectController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [:create]
  before_action :set_artifacts, only: [:read]

  def read
    render 'organization/project'
  end

  def create
    Project.create(project_params)
    redirect_to(organization_projects_path)
  end

  def update
    @project.update(project_params)
  end

  def delete
    @project.destroy
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
