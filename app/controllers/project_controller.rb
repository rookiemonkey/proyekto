class ProjectController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [:create]
  before_action :redirect_if_project_is_disabled, except: [:create]
  before_action :set_artifacts, only: [:read]

  def read
    render 'organization/project'
  end

  def create
    created_project = Project.create(project_params)
    raise ResourceError.new(message: get_error_for(created_project)) unless created_project.valid?

    trigger_activity("Project '#{project_params[:name]}' has been created by #{current_user.full_name}")
    redirect_success('Project successfully created!', organization_projects_path)
  end

  def update
    raise ResourceError.new(message: get_error_for(@project)) unless @project.update(project_params)

    trigger_activity("Project '#{@project.name}' has been updated by #{current_user.full_name}")
    redirect_back_success('Project successfully updated!')
  end

  def delete
    @project.destroy
    trigger_activity("Project '#{@project.name}' has been deleted by #{current_user.full_name}")
    redirect_back_success('Project successfully deleted!')
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

  def trigger_activity(description)
     Activity.create_project_activity(description)
  end
end
