class AddIsDisabledForArtifacts < ActiveRecord::Migration[6.1]
  def change
    add_column :artifacts, :disabled, :boolean
    change_column_default :artifacts, :disabled, false
  end
end
