class Users::RegistrationsController < Devise::RegistrationsController
  layout 'landing'

  def create
    build_resource(sign_up_with_organization_parameters)
    resource.save

    if resource.persisted?
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)
      respond_with resource, location: organization_dashboard_path
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def sign_up_with_organization_parameters
    org_name = sign_up_params[:organization]
    update = { organization: nil }
    found_organization = Organization.find_by(name: org_name)
    update[:organization] = found_organization if found_organization
    update[:organization] = Organization.create(name: org_name) unless found_organization
    sign_up_params.update(update)
  end
end
