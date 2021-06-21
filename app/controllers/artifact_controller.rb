class ArtifactController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_artifact, only: %i[update delete]
  before_action :redirect_if_artifact_is_disabled, only: %i[update delete]
  before_action :validate_image_upload, only: %i[create]

  def read_all
    @pagy, @artifacts = pagy(@project.artifacts, items: 30)
    render 'organization/artifacts'
  end

  def create
    upload_details = { image_url: nil, image_name: nil }
    upload_details = Gcloud.upload(artifact_image.tempfile.path, artifact_image_name) if artifact_image
    created_artifact = Artifact.create(**artifact_params, **upload_details, project_id: params[:pid])
    raise ResourceError.new(message: get_error_for(created_artifact)) unless created_artifact.valid?

    trigger_activity("Artifact '#{artifact_params[:name]}' has been created by #{current_user.full_name}")
    redirect_back_success('Artifact successfully created!')
  end

  def update
    upload_details = {}
    upload_details = Gcloud.upload(artifact_image.tempfile.path, @artifact.image_name || artifact_image_name) if artifact_image
    raise ResourceError.new(message: get_error_for(@artifact)) unless @artifact.update(**artifact_params, **upload_details)

    trigger_activity("Artifact '#{@artifact.name}' has been updated by #{current_user.full_name}")
    redirect_back_success('Artifact successfully updated!')
  end

  def delete
    @artifact.destroy
    trigger_activity("Artifact '#{@artifact.name}' has been deleted by #{current_user.full_name}")
    redirect_back_success('Artifact successfully deleted!')
  end

  private

  def set_artifact
    @artifact = @project.artifacts.find(params[:aid])
  end

  def artifact_params
    params.require(:artifact).permit(:name, :description)
  end

  def artifact_image
    params.require(:artifact).permit(:image)[:image]
  end

  def validate_image_upload
    return unless artifact_image

    raise UploadError.new(message: 'File is not an image') if invalid_image_format

    raise UploadError.new(message: 'File is too big') if reached_image_size_limit
  end

  def reached_image_size_limit
    artifact_image.size > 1_000_000
  end

  def invalid_image_format
    file_analysis = MimeMagic.by_magic(File.open(artifact_image.tempfile.path))
    %w[jpg jpeg png].exclude? file_analysis.subtype
  end

  def artifact_image_name
    period = artifact_image.original_filename.rindex('.')
    extension = artifact_image.original_filename[period, artifact_image.original_filename.length]
    "#{IdGenerator.generate}#{extension}"
  end

  def trigger_activity(description)
    Activity.create_artifact_activity(description)
  end
end
