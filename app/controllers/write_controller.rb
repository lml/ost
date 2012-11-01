# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class WriteController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]
  
  def index
    redirect_to "mailto:#{params[:to]}@openstaxtutor.org"
  end
end
