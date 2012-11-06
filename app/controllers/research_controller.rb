# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class ResearchController < ApplicationController
  before_filter :authenticate_researcher_or_admin!

  def index
  end
end
