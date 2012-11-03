# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class UsersController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:become]
  before_filter :authenticate_admin!, :except => [:become]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    @user.is_administrator = params[:user][:is_administrator]
    if params[:user][:disable].blank?
      @user.enable!
    else
      @user.disable!
    end
    
    respond_with(@user)
  end
  
  def confirm
    @user = User.find(params[:user_id])
    @user.confirm!
    redirect_to(user_path(@user))
  end
  
  def become
    raise SecurityTransgression unless Rails.env.development? || current_user.is_administrator?
    
    sign_in(:user, User.find(params[:user_id]))

    if params[:redirect_to_root]
      redirect_to root_path
    else
      redirect_to request.referer
    end
  end

end
