class ColleagueController < ApplicationController
  def create
    User.create(**colleague_params, **colleague_default_params)
  end

  private

  def colleague_params
    params.require(:colleague).permit(:full_name, :email, :new_password, :new_password_confirm)
  end

  def colleague_default_params
    { password: IdGenerator.generate, invitation_id: IdGenerator.generate, organization: current_tenant }
  end
end
