class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_tenant_based_on_user_organization

  def set_project
    @project = Project.find(params[:pid])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name])
  end

  def set_current_tenant_based_on_user_organization
    set_current_tenant(nil) unless current_user
    set_current_tenant(Organization.find(current_user.organization.id)) if current_user
  end
end
