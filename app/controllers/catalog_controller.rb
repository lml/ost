# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class CatalogController < ApplicationController
  
  skip_before_filter :authenticate_user!
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy
  
  def index
    @courses = Course.all
  end
end
