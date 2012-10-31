# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class CatalogController < ApplicationController
  
  skip_before_filter :authenticate_user!
  
  def index
    @courses = Course.all
  end
end
