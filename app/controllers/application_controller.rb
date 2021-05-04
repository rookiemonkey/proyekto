class ApplicationController < ActionController::Base
  include Exceptions::ApplicationErrors
  rescue_from UploadError, with: :handle_upload_error

  set_current_tenant_through_filter
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_tenant_based_on_user_organization

  def set_project
    @project = Project.find(params[:pid])
  end

  def set_artifacts
    @artifacts = @project.artifacts
  end

  def short_id
    DateTime.now.strftime('%Y%m%d%k%M%S%L').to_i.to_s(36)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name organization])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name organization])
  end

  def set_current_tenant_based_on_user_organization
    set_current_tenant(nil) unless current_user
    set_current_tenant(Organization.find(current_user.organization.id)) if current_user
  end

  def handle_upload_error(error)
    flash[:alert] = error.message
    redirect_back(fallback_location: organization_dashboard_path)
  end
end
