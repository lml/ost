# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Prepend ensures we run those filters before authenticate_admin! no matter what
  prepend_before_filter :user_not_disabled!,
                        :site_not_in_maintenance!,
                        :authenticate_user!

  before_filter :enable_miniprofiler_for_devs

  before_filter :set_user_time_zone
  before_filter :include_jquery
  before_filter :include_timepicker
  before_filter :use_2_column_layout

  helper_method :user_is_disabled?,
                :site_in_maintenance?,
                :user_is_admin?,
                :present_user,
                :view_dir,
                :view_dir_from_string,
                :enable_clock

  unless Ost::Application.config.consider_all_requests_local
    rescue_from Exception, :with => :rescue_from_exception
  end

  respond_to :html

protected

  def rescue_from_exception(exception)
    error_page = 500
    send_email = true

    case exception
    when SecurityTransgression
      error_page = 403
      send_email = false
    when ActiveRecord::RecordNotFound, 
         ActionController::RoutingError,
         ActionController::UnknownController,
         ActionController::UnknownAction
      error_page = 404
      send_email = false
    when NotYetImplemented
      error_page = "nyi"
      send_email = false
    end

    render_error_page(error_page)
    DeveloperNotifier.exception_email(exception, present_user) if send_email
  end

  def render_error_page(status)
    page = status

    if "nyi" == "status"
      page = "nyi"
      status = 404
    end

    respond_to do |type| 
      type.html { render :template => "errors/#{status}", :layout => 'application', :status => status } 
      type.all  { render :nothing => true, :status => status } 
    end    
  end

  def protect_beta
    return if !Rails.env.production?

    authenticate_or_request_with_http_basic do |username, password|
      username == "ost" && password == "ost"
    end
  end


  # A user can be logged in but later be deauthorized for any number of reasons
  # (essentially locked out).  Going through this helper method gives us a 
  # place to put extra logic
  def user_is_disabled?
    present_user.is_disabled? # Always false for Anonymous
  end

  def user_not_disabled!
    !user_is_disabled? || redirect_user_disabled
  end

  def site_in_maintenance?
    WebsiteConfiguration.get_value(:in_maintenance)
  end

  def site_not_in_maintenance!
    !site_in_maintenance? || 
    (present_user.is_administrator? && 
    flash.now[:notice] = "#{SITE_NAME} is currently undergoing maintenance.
                          Non-admin login is disabled.") ||
    (present_user.is_anonymous? &&
    flash.now[:notice] = "#{SITE_NAME} is currently undergoing maintenance.
                           User login is disabled.") ||
    redirect_maintenance
  end

  def user_is_admin?
    user_signed_in? && current_user.is_administrator?
  end

  def authenticate_admin!
    raise SecurityTransgression unless user_is_admin?
  end
  
  def authenticate_researcher_or_admin!
    raise SecurityTransgression unless user_is_admin? || present_user.is_researcher?
  end

  # Like current_user, but for users who aren't logged in returns an 
  # AnonymousUser instead of nil
  def present_user
    current_user || AnonymousUser.instance
  end

  def redirect_user_disabled
    respond_to do |format|
      format.html do
        flash[:alert] = "Your account has been disabled. Please contact the administration if you wish to re-enable it."
        if user_signed_in?
          sign_out current_user
        end
        redirect_to root_path
      end
      format.any do
        render :text => "Your account has been disabled. Please contact the administration if you wish to re-enable it.", :status => :unauthorized, :layout => false
      end
    end
  end

  def redirect_maintenance
    respond_to do |format|
      format.html do
        if user_signed_in?
          sign_out current_user
        end
        redirect_to new_user_session_path
      end
      format.any do
        render :text => "#{SITE_NAME} is currently undergoing maintenance. User login is disabled.", :status => :unauthorized, :layout => false
      end
    end
  end

  def enable_timeout
    # disable in development
    @enable_timeout = !Rails.env.development?
  end

  def is_id?(value)
    /^\d+$/ === value
  end

  def include_jquery
    @include_jquery = true
  end

  def include_timepicker
    @include_timepicker = true
  end

  def use_2_column_layout
    @use_2_column_layout = true
  end

  def turn_on_consenting(consentable)
    return if consentable.nil? || consentable.not_currently_consentable?

    @consenting_enabled = true
    @consent = consentable.consent
    @consentable = consentable

    if @consent.nil? || @consent.ready_for_reask?    
      @ask_for_consent = true
    end
  end
  
  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end
  
  def view_dir(object)
    view_dir_from_string(object.type)
  end

  def view_dir_from_string(string) 
    string.underscore.pluralize
  end
  
  def enable_clock
    @clock_enabled = true
  end
  
  def enable_miniprofiler_for_devs
    if Rails.env.development? || user_is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end
  
  def sort(params_name, model_class, parent = nil, parent_method = nil)
    sorted_ids = params[params_name]
    return if sorted_ids.blank?
  
    items = model_class.find(sorted_ids)
  
    items.each do |item|
      if !parent.nil? && !parent_method.nil?
        raise SecurityTransgression unless item.send(parent_method) == parent
      end
      raise SecurityTransgression unless item.can_be_sorted_by?(present_user)      
    end
    
    begin 
      model_class.sort!(sorted_ids)
    rescue Exception => invalid
      flash[:alert] = "An error occurred: #{invalid.message}"
    end
    
    # render :template => 'shared/sort'
  end

end
