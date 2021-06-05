module Plans::Free
  def free(organization)
    num_of_available_projects = (::Plans.available_plans[:free][:project_limit]) - 1

    Project.where(organization: organization).order(created_at: :desc).each_with_index do |project, index|
      next if index <= num_of_available_projects
      next if project.disabled

      project.update(disabled: true)
      project.artifacts.each { |artifact| artifact.update(disabled: true) }
    end
  end
end
