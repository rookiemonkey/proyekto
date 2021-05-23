class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Exceptions::ApplicationErrors
  rescue_from ActiveRecord::RecordNotFound, with: :to_redirect_back_not_found
  rescue_from Pagy::OverflowError, with: :page_overflow
  rescue_from IsAlreadyLoggedInError, with: :to_redirect_back
  rescue_from UploadError, with: :to_redirect_back
  rescue_from ResourceError, with: :to_redirect_back

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

  def get_error_for(resource)
    resource.errors.full_messages.first
  end

  def redirect_if_logged_in
    raise IsAlreadyLoggedInError.new(message: 'Oh no!') if user_signed_in?
  end

  def redirect_back_success(message)
    flash[:notice] = message
    redirect_back(fallback_location: organization_dashboard_path)
  end

  def redirect_success(message, path)
    flash[:notice] = message
    redirect_to(path)
  end

  def redirect_if_project_is_disabled
    raise ResourceError.new(message: 'Resource is disabled due to plan restrictions. Please upgrade your plan to regain access', path: organization_projects_path) if @project.disabled
  end

  def redirect_if_artifact_is_disabled
    raise ResourceError.new(message: 'Resource is disabled due to plan restrictions. Please upgrade your plan to regain access') if @artifact.disabled
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

  def to_redirect_back(error)
    flash[:alert] = error.message
    redirect_back(fallback_location: error.path.nil? ? organization_dashboard_path : error.path)
  end

  def to_redirect_back_not_found
    flash[:alert] = 'Resource not found'
    redirect_back(fallback_location: organization_dashboard_path)
  end

  def page_overflow
    flash[:notice] = 'You\'ve reached the last page'
    redirect_back(fallback_location: organization_dashboard_path)
  end
end
