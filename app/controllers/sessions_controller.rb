# http://stackoverflow.com/questions/10153040/stop-devise-from-clearing-session

class SessionsController < Devise::SessionsController

  fine_print_skip_signatures :general_terms_of_use, :privacy_policy

  def create
    super
    session[:was_ever_logged_in_as_admin] = true if current_user.is_administrator?
  end

  def destroy
    was_ever_logged_in_as_admin = session[:was_ever_logged_in_as_admin] 
    super  
    session[:was_ever_logged_in_as_admin] = was_ever_logged_in_as_admin
  end

end