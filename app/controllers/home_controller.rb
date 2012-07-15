class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:index, :terms, :contact, :contact_submit]

  def index; end
  def terms; end
  
  def contact
    @topic = params[:topic]
  end
  
  def contact_submit
    @errors = {:base => []}
    
    @name = params[:name]
    @email = params[:email]
    @email_confirm = params[:email_confirm]
    @topic = params[:topic]
    @message = params[:message]
    
    @errors[:base].push("Please provide your email address.") if @email.blank?
    @errors[:base].push("Please provide your name.") if @name.blank?
    @errors[:base].push("Please provide a message.") if @message.blank?
    @errors[:base].push("Your email address confirmation didn't match.") if @email != @email_confirm
    @errors[:base].push("Your reCAPTCHA entry was incorrect.") if !user_signed_in? && !verify_recaptcha

    if !@errors[:base].empty?
      render action: 'contact'
    else
      ContactUsMailer.submission(params).deliver
      flash[:notice] = "Thanks for sending us a message!  Your feedback is important to us."
      redirect_to root_path
    end
  end
  
end
