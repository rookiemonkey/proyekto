class ColleagueMailer < ApplicationMailer
  def invitation_email
    @colleague = params[:colleague]
    @confirm_url = new_organization_colleague_url + "?invitation_id=#{@colleague.invitation_id}"
    @decline_url = decline_organization_colleague_url + "?invitation_id=#{@colleague.invitation_id}"
    mail(to: @colleague.email, subject: 'Invitation to ORGANIZATION_NAME')
  end
end
