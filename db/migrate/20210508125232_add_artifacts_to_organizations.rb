class AddArtifactsToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_reference :artifacts, :organization, foreign_key: true, index: true
  end
end
