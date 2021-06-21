class OrganizationController < ApplicationController
  before_action :authenticate_user!

  def dashboard; end

  def projects
    @projects = Project.all
  end

  def colleagues
    @colleagues = User.all
  end

  def artifacts
    @pagy, @artifacts = pagy(Artifact.where(disabled: false), items: 30)
  end

  def update_plan
    success = current_tenant.update(new_plan)
    message = success ? 'Successfully updated your plan' : current_tenant.errors.full_messages.first
    trigger_activity("#{current_user} updated your plan to '#{new_plan}'")
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
