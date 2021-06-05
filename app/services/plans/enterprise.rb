module Plans::Enterprise
  def enterprise(organization)
    Project.where(organization: organization).each do |project|
      project.update(disabled: false)
      project.artifacts.each { |artifact| artifact.update(disabled: false) }
    end
  end
end
