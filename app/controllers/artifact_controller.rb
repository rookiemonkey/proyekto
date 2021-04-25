class ArtifactController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_artifact, only: %i[read_one update delete]

  def read_all
    @artifacts = @project.artifacts
    render 'organization/artifacts'
  end

  def read_one
    render 'organization/artifact'
  end

  def create
    Artifact.create(**artifact_params, project_id: params[:pid])
  end

  def update
    @artifact.update(artifact_params)
  end

  def delete
    @artifact.destroy
  end

  private

  def artifact_params
    params.require(:artifact).permit(:name, :description)
  end

  def set_artifact
    @artifact = @project.artifacts.find(params[:aid])
  end
end
