# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class HelpController < ApplicationController

  skip_before_filter :authenticate_user!
  
  before_filter :highlight_help

  # This class variable maps topic names to partial names.  This is mostly
  # useful when the blurb name does not match the partial name.  If 
  # your blurb name is not in this hash, the site will use the blurb name
  # as the partial name
  @@blurb_partial_names = {
    # "some blurb name here" => "corresponding partial name here",
  }

  def blurb
    @partial_name = @@blurb_partial_names[params[:blurb_name]] || params[:blurb_name]
    @options = params[:options] || {}

    respond_to do |format|
      format.html
      format.js
    end
  end
  
protected

  def highlight_help
    @highlight = :help
  end
  
end
