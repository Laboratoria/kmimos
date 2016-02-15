class BookingsController < ApplicationController 
  
  before_action :set_booking, only: [:show,:destroy]
  before_action :authenticate_user!, except: [:new, :booking_resume]
  
  caches_page   :public
  caches_action :booking_resume

  def index
    @bookings = Booking.where(user_id: current_user)

  end
 
  def booking_resume
    @booking = Booking.find(params[:booking_id]) 
    
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(layout: false)
        kit = PDFKit.new(html, page_size: 'A4', print_media_type: true)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/extra.scss"
        pdf = kit.to_pdf
        send_data pdf, filename: 'booklet.pdf', type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def new
    if user_signed_in?
      @services =  params[:services] != nil ? Service.where(id: params[:services]) : []
      @provider = Provider.find(params[:booking][:provider_id])
      @booking = Booking.new
      @booking.start_date = session[:from_date]
      @booking.end_date = session[:to_date]
    else
      redirect_to '/users/sign_in'
    end
  end

  def show
    @booking = Booking.where(token: params[:id]).last
  end

  def create

    @provider = Provider.find(params[:provider_id])
    @booking = Booking.new(booking_params)

    @booking.provider_id  = @provider.id
    @booking.user_id = current_user.id

    if @booking.save

      BookingConfirmationMailer.new_booking_notification(@booking, current_country).deliver
      BookingConfirmationMailer.new_booking_provider_notification(@booking, current_country).deliver
      BookingConfirmationMailer.new_booking_for_admin(@booking, current_country).deliver

      session[:from_date], session[:to_date] = nil, nil
      redirect_to booking_path(@booking)
    else
      render 'new'
    end
  end

  def send_mail
    @provider = Provider.find(params[:provider_id])
    @booking = Booking.find(params[:booking_id])

    BookingConfirmationMailer.new_booking_notification(@booking, current_country).deliver
    BookingConfirmationMailer.new_booking_provider_notification(@booking, current_country).deliver
    BookingConfirmationMailer.new_booking_for_admin(@booking, current_country).deliver
    
    render :text => "Correo enviado a " + @provider.name + "(" + @provider.id.to_s + ") con la reserva " + @booking.id.to_s + "."
  end  

  private

  def booking_params
    params.require(:booking).permit! #(:raza, :edad, :cuidado_especial, :start_date, :end_date, :user_first_name, :user_last_name, :provider_id, :user_phone, :user_email, :ref_code, :user_message, :address, :pickup_time, :dropoff_time, :pet_name)
  end

  def set_booking
    @booking = Booking.find_by_token(params[:id])
  end



end
