class ColleagueController < ApplicationController
  def create
    invited_colleague = User.create(**colleague_params, **colleague_default_params)
    ColleagueMailer.with(colleague: invited_colleague).invitation_email.deliver_later
  end

  def accept
    invited_colleague = User.find_by(invitation_id: colleague_params[:invitation_id])
    invited_colleague.password = colleague_params[:invite_new_password]
    invited_colleague.invitation_id = nil
    invited_colleague.save
    redirect_to(new_user_session_path)
  end

  private

  def colleague_params
    params.require(:colleague).permit(:full_name, :email, :invite_new_password, :invite_new_password_confirm, :invitation_id)
  end

  def colleague_default_params
    { password: IdGenerator.generate, invitation_id: IdGenerator.generate, organization: current_tenant }
  end
end
