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
  
  def become
    raise SecurityTransgression unless Rails.env.development? || current_user.is_administrator?
    
    sign_in(:user, User.find(params[:user_id]))
    redirect_to request.referer # root_path
  end

end
