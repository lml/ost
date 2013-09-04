# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class HomeController < ApplicationController

  include ApplicationHelper

  skip_before_filter :authenticate_user!, :only => [:index, :terms, :contact, :contact_submit, :about]

  def index; end
  def terms; 
    @site_license = SiteLicense.latest
  end
  
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
      ContactUsMailer.submission(filter_params(params)).deliver
      flash[:notice] = "Thanks for sending us a message!  Your feedback is important to us."
      redirect_to root_path
    end
  end
  
  def dashbaord
    
  end
  
end
