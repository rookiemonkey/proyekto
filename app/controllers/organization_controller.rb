class OrganizationController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @num_of_projects = Project.count
    @num_of_artifacts = Artifact.count
    @num_of_staffs = User.count
  end

  def projects
    @projects = Project.all
    @activities = Activity.where(activity_type: 'project').order(created_at: :desc).limit(10)
  end

  def colleagues
    @colleagues = User.all
    @activities = Activity.where(activity_type: 'staff').order(created_at: :desc).limit(10)
  end

  def artifacts
    @pagy, @artifacts = pagy(Artifact.where(disabled: false), items: 30)
    @activities = Activity.where(activity_type: 'artifact').order(created_at: :desc).limit(10)
  end

  def update_plan
    success = current_tenant.update(new_plan)
    message = success ? 'Successfully updated your plan' : current_tenant.errors.full_messages.first
    trigger_activity("#{current_user.full_name} updated your plan to '#{new_plan[:plan]}'")
    render json: { success: success, message: message }
  end

  private

  def new_plan
    params.require('plan').permit(:plan)
  end

  def trigger_activity(description)
    Activity.create_account_activity(description)
  end
end
