class AddProjectsToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_reference :projects, :organization, foreign_key: true, index: true
  end
end
