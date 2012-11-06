# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class LearningConditionsController < ApplicationController

  before_filter :get_klass, :only => [:index]

  def index
    # LCs are not really direct children of klass, but that's ok
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :learning_conditions)
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end
  
end
