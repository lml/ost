# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

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
