include Ost::Cron

class AdminController < ApplicationController
  
  before_filter :authenticate_admin!

  def index
  end
  
  def cron
    Ost::execute_cron_jobs
    flash[:notice] = "Ran cron tasks"
    redirect_to admin_path  
  end
end
