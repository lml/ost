require 'mail'

class MailHooksController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!

  def catch
    mail = Mail.new(params[:message])

    begin
      outcome = MailHook.process(mail)
    rescue MailHookNoMatches => e
      Rails.logger.info("MailHook: #{e.inspect}")
      render status: 404, text: 'incoming email subject and addressee were not expected'
    rescue MailHookHookableError => e
      Rails.logger.info("MailHook: #{e.inspect}")
      render status: 422, text: 'an unknown error occurred when processing the inbound email'
    else
      render status: 200, text: 'success'
    end      
  end

end
