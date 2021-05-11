class ColleagueController < ApplicationController
  layout 'landing'
  before_action :find_invited_colleague, only: %i[new accept decline]

  def new
    render 'users/new_colleague'
  end

  def create
    invited_colleague = User.create(**colleague_params, **colleague_default_params)
    ColleagueMailer.with(colleague: invited_colleague).invitation_email.deliver_later
    redirect_back(fallback_location: organization_dashboard_path)
  end

  def accept
    @invited_colleague.password = colleague_params[:invite_new_password]
    @invited_colleague.invitation_id = nil
    @invited_colleague.save
    redirect_to(new_user_session_path)
  end

  def decline
    @invited_colleague.destroy
    redirect_to(root_path)
  end

  private

  def colleague_params
    params.require(:colleague).permit(:full_name, :email, :invite_new_password, :invite_new_password_confirm)
  end

  def colleague_default_params
    { password: IdGenerator.generate, invitation_id: IdGenerator.generate, organization: current_tenant }
  end

  def find_invited_colleague
    @invited_colleague = User.find_by(invitation_id: params[:invitation_id])
  end
end
