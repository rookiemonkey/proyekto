class ColleagueMailer < ApplicationMailer
  def invitation_email
    @colleague = params[:colleague]
    @confirm_url = "/colleagues/new?invitation_id=#{@colleague.invitation_id}"
    mail(to: @colleague.email, subject: 'Invitation to ORGANIZATION_NAME')
  end
end
