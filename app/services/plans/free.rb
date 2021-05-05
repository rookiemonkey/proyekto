module Plans::Free
  def free(organization)
    num_of_available_projects = (::Plans.available_plans[:free][:project_limit]) - 1

    Project.where(organization: organization).reverse.each_with_index do |project, index|
      next if index <= num_of_available_projects
      next if project.disabled.is_a?(TrueClass)

      project.update(disabled: true)
    end
  end
end
