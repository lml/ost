require 'mail'

class MailHooksController < ApplicationController

  include ApplicationHelper

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!

  def catch
    mail = MailFactory.from_cloudmailin_json(params)

    begin
      outcome = MailHook.process(mail)
    rescue MailHookNoMatch => e
      Rails.logger.info("MailHook: #{e.inspect}")
      # Used to be a 404, but that might have been ticking off our uploads@ email provider
      render status: 202, text: 'incoming email subject and addressee were not expected'
    rescue MailHookHookableError => e
      Rails.logger.info("MailHook: #{e.inspect}")
      Rails.logger.info("inside error: #{e.original.inspect}")
      DeveloperNotifier.exception_email(e, nil, "MailHook unexpected error")
      # Used to be a 422, but that might have been ticking off our uploads@ email provider
      render status: 202, text: 'an unknown error occurred when processing the inbound email'
    else
      render status: 200, text: 'success'
    end      
  end

end
