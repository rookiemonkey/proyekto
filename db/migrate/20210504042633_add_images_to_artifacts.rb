class AddImagesToArtifacts < ActiveRecord::Migration[6.1]
  def change
    add_column :artifacts, :image_url, :string, null: true
    add_column :artifacts, :image_name, :string, null: true
  end
end
