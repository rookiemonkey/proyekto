class AddIsDisabledForProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :disabled, :boolean
    change_column_default :projects, :disabled, false
  end
end
