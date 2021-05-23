module Plans::Enterprise
  def enterprise(organization)
    num_of_available_projects = (::Plans.available_plans[:enterprise][:project_limit]) - 1

    Project.where(organization: organization).reverse.each_with_index do |project, index|
      next if index <= num_of_available_projects
      next if project.disabled.is_a?(FalseClass)

      project.update(disabled: false)
      project.artifacts.each { |artifact| artifact.update(disabled: false) }
    end
  end
end
