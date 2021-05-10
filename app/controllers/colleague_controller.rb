class ColleagueController < ApplicationController
  def create
    invited_colleague = User.create(**colleague_params, **colleague_default_params)
    ColleagueMailer.with(colleague: invited_colleague).invitation_email.deliver_now
  end

  private

  def colleague_params
    params.require(:colleague).permit(:full_name, :email, :new_password, :new_password_confirm)
  end

  def colleague_default_params
    { password: IdGenerator.generate, invitation_id: IdGenerator.generate, organization: current_tenant }
  end
end
