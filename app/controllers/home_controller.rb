# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class HomeController < ApplicationController

  include ApplicationHelper

  no_login_actions = [:index, :terms, :contact, :contact_submit, :about, :quick_close]

  skip_before_filter :authenticate_user!, :only => no_login_actions
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy, :only => no_login_actions

  def index; end

  def terms
    @contracts = [FinePrint.get_contract(:general_terms_of_use),
                 FinePrint.get_contract(:privacy_policy)].compact
    if @contracts.length != 2
      redirect_to root_path, alert: 'The terms are temporarily unavailable.  Check back soon.'
    end
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

  def quick_close
    render layout: false
  end
  
end
