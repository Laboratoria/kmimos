class BookingConfirmationMailer < ActionMailer::Base
  default from: "\"Kmimos\" <reservas@cani.mx>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.business_mailer.new_record_notification.subject
  #
  def new_booking_notification(booking)
    @booking = booking
    mail(
      to: @booking.user_email,
      cc: "r.gonzalez@desdigitec.com",
      subject: 'Reserva realizada.')
  end
end
