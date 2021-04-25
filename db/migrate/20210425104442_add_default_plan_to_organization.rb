class AddDefaultPlanToOrganization < ActiveRecord::Migration[6.1]
  def change
    change_column_default :organizations, :plan, 'free'
  end
end
