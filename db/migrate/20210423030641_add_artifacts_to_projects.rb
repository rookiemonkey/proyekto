class AddArtifactsToProjects < ActiveRecord::Migration[6.1]
  def change
    add_reference :artifacts, :project, foreign_key: true, index: true
  end
end
