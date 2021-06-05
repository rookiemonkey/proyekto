module Plans::Standard
  def standard(organization)
    num_of_available_projects = (::Plans.available_plans[:standard][:project_limit]) - 1

    Project.where(organization: organization).order(created_at: :desc).each_with_index do |project, index|
      if index <= num_of_available_projects
        next unless project.disabled
        project.update(disabled: false)
        project.artifacts.each { |artifact| artifact.update(disabled: false) }
      else
        next if project.disabled
        project.update(disabled: true)
        project.artifacts.each { |artifact| artifact.update(disabled: true) }
      end
    end
  end
end
