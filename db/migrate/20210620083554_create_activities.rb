class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :description
      t.string :activity_type, null: true
      t.references :organization, foreign_key: true, index: true
      t.timestamps
    end
  end
end
