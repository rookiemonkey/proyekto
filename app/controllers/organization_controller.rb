class OrganizationController < ApplicationController
  before_action :authenticate_user!

  def dashboard; end

  def projects
    @projects = Project.all
  end

  def colleagues
    @colleagues = User.all
  end
end