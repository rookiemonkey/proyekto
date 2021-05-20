class ColleagueController < ApplicationController
  layout 'landing'
  before_action :authenticate_user!, only: %i[create]
  before_action :redirect_if_logged_in, except: %i[create]
  before_action :find_invited_colleague, only: %i[new accept decline]

  def new
    render 'users/new_colleague'
  end

  def create
    invited_colleague = User.create(**colleague_params, **colleague_default_params)
    raise ResourceError.new(message: get_error_for(invited_colleague)) unless invited_colleague.valid?

    ColleagueMailer.with(colleague: invited_colleague).invitation_email.deliver_later
    redirect_back_success('Invitation Email successfully sent to colleague!')
  end

  def accept
    redirect_path = "#{request.url}?invitation_id=#{params[:invitation_id]}"
    raise ResourceError.new(message: 'Password does\'nt match', path: redirect_path) unless passwords_match

    @invited_colleague.password = colleague_params[:invite_new_password]
    @invited_colleague.invitation_id = nil
    @invited_colleague.save
    raise ResourceError.new(message: get_error_for(@invited_colleague), path: redirect_path) unless @invited_colleague.valid?

    redirect_success('Successfully created your account! Please login to continue', new_user_session_path)
  end

  def decline
    @invited_colleague.destroy
    redirect_success('Successfully declined the organization invitation!', root_path)
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
    raise ResourceError.new(message: 'Resource not found', path: new_user_session_path) unless @invited_colleague
  end

  def passwords_match
    colleague_params[:invite_new_password] == colleague_params[:invite_new_password_confirm]
  end
end
