class MeetingConfirmationMailer < ActionMailer::Base
  default from: "\"Kmimos\" <reservas@cani.mx>"


  def new_meeting_notification(meeting, current_country)
    @meeting = meeting
    @country = current_country
    mail(
      to: @meeting.user_email,
      subject: 'Solicitud recibida.')
  end

  def new_meeting_for_admin(meeting, current_country)
    @meeting = meeting    
    @country = current_country
    admins = []
    admins << "r.gonzalez@desdigitec.com" << "e.celli@desdigitec.com"
    # Panamá
    if @country.id == 3
      admins << "nenavieira@gmail.com" << "bobthin@gmail.com"
    end
    mail(
      # to: "adelrio@ayuinc.com",
      to: "r.cuevas@desdigitec.com",
      cc: admins,
      subject: 'Nueva solicitud en Kmimos' + @country.name)
  end
end
