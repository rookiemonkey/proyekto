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
end
