# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class ResourcesController < ApplicationController
  
  before_filter :get_topic, :only => [:new, :create, :sort]

  respond_to :js

  def new
    @resource = Resource.new
    @resource.topic = @topic
    raise SecurityTransgression unless present_user.can_create?(@resource)
  end

  def edit
    @resource = Resource.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@resource)
  end

  def create
    @resource = Resource.new(params[:resource])
    @resource.topic = @topic
    raise SecurityTransgression unless present_user.can_create?(@resource)
    @resource.save
    render :template => 'resources/create_update'
  end

  def update
    @resource = Resource.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@resource)
    @resource.update_attributes(params[:resource])
    render :template => 'resources/create_update'
  end

  def destroy
    @resource = Resource.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@resource)
    @resource.destroy
  end

  def sort
    sorted_ids = params['sortable_item']
    return if sorted_ids.blank?

    sorted_ids.each do |sorted_id|
      resource = Resource.find(sorted_id)
      raise SecurityTransgression unless resource.topic == @topic
      raise SecurityTransgression unless resource.can_be_sorted_by?(present_user)
    end

    begin 
      Resource.sort!(sorted_ids)
    rescue
      flash[:alert] = "An unknown error occurred."
    end
  end

protected

  def get_topic
    @topic = Topic.find(params[:topic_id])
  end
end
