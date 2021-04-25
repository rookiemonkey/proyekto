class Users::SessionsController < Devise::SessionsController
  layout 'landing'

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    respond_with resource, location: organization_dashboard_path
  end
end
