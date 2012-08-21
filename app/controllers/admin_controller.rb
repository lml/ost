
class AdminController < ApplicationController
  
  before_filter :authenticate_admin!

  def index
  end
  
  def cron
    AssignmentPlan.build_and_distribute_assignments
    StudentAssignment.note_if_due!
    flash[:notice] = "Ran cron tasks"
    redirect_to admin_path  
  end
end
