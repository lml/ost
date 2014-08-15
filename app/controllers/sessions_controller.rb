# http://stackoverflow.com/questions/10153040/stop-devise-from-clearing-session

class SessionsController < Devise::SessionsController

  fine_print_skip_signatures :general_terms_of_use, :privacy_policy

  skip_before_filter :enable_miniprofiler_for_devs

  layout :layout

  def new
    terp? ?
      render('terp/sign_in', terp_id: params[:terp_id]) :
      render('new')
  end

  def create
    super
    session[:was_ever_logged_in_as_admin] = true if current_user.is_administrator?
  end

  def destroy
    was_ever_logged_in_as_admin = session[:was_ever_logged_in_as_admin] 
    super  
    session[:was_ever_logged_in_as_admin] = was_ever_logged_in_as_admin
  end

  def layout
    terp? ? 'terp' : 'application'
  end

  def terp?
    session[:terp]
  end

end