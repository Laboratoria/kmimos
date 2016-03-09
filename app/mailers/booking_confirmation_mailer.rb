class BookingConfirmationMailer < ActionMailer::Base
  #default from: "\"Kmimos\" <reservas@cani.mx>" 
  default from: "\"Kmimos\" <contacto@kmimos.la>" 

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.business_mailer.new_record_notification.subject
  #
  def new_booking_notification(booking, current_country) 
    @booking = booking
    @country = current_country
    @url = ActionMailer::Base.default_url_options
    mail(
      to: [ @booking.user.email, "r.gonzalez@desdigitec.com", "e.celli@desdigitec.com", "m.castellon@desdigitec.com" ],
      subject: 'Tu reserva en Kmimos.')
  end
  
  def new_booking_for_admin(booking, current_country)
    @booking = booking
    @country = current_country
    @url = ActionMailer::Base.default_url_options
    admins = []
    admins << "r.gonzalez@desdigitec.com" << "e.celli@desdigitec.com" << "f.trujillo@desdigitec.com" << "m.castellon@desdigitec.com"

    # Panamá
    if @country.id == 3
      admins << "nenavieira@gmail.com" << "bobthin@gmail.com"
    end
    
    mail(
      to: "r.cuevas@desdigitec.com",
      cc: admins,
      subject: 'Nueva reserva en Kmimos ' + @country.name)
 
  end
  
  def new_booking_provider_notification(booking, current_country) 
    @booking = booking
    @country = current_country
    @url = ActionMailer::Base.default_url_options
    mail(
      to: @booking.provider.email,
      subject: 'Reserva realizada.')
  end
end
