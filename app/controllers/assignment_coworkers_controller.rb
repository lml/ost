# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentCoworkersController < ApplicationController

  before_filter :get_student_assignment, :only => [:new, :search, :create]

  def new
    coworker = AssignmentCoworker.new
    coworker.student_assignment = @student_assignment
    raise SecurityTransgression unless present_user.can_create?(coworker)
    
    @action_dialog_title = "Add a coworker"
    @action_search_path = search_student_assignment_assignment_coworkers_path

    respond_to do |format|
      format.js { render :template => 'users/action_new' }
    end
  end

  def search
    coworker = AssignmentCoworker.new
    coworker.student_assignment = @student_assignment
    raise SecurityTransgression unless present_user.can_create?(coworker)
    
    @selected_type = params[:selected_type]
    @text_query = params[:text_query]
    # Limit users to those in the same section and with the same auditing status
    @users = User.joins(:students)
                 .where(:students => {:cohort_id => @student_assignment.assignment.cohort_id,
                                      :is_auditing => @student_assignment.student.is_auditing})
                 .search(@selected_type, @text_query)

    @users.reject! do |user| 
      user == present_user || @student_assignment.is_coworker?(user)
    end    

    @action_partial = 'users/action_create_form'
    @action_partial_target = [@student_assignment, AssignmentCoworker.new]

    respond_to do |format|
      format.js { render :template => 'users/action_search' }
    end
  end

  def create
    @assignment_coworker = AssignmentCoworker.new
    @assignment_coworker.student = 
      Student.where(:user_id => params[:assignment_coworker][:user_id])
             .where(:cohort_id => @student_assignment.assignment.cohort_id)
             .first
    @assignment_coworker.student_assignment = @student_assignment

    raise SecurityTransgression unless present_user.can_create?(@assignment_coworker)

    @assignment_coworker.save
  end

  def destroy
    @assignment_coworker = AssignmentCoworker.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@assignment_coworker)
    @assignment_coworker.destroy

    respond_to do |format|
      format.html { redirect_to(assignment_path(@assignment_coworker.student_assignment.assignment)) }
    end
  end

protected

  def get_student_assignment
    @student_assignment = StudentAssignment.find(params[:student_assignment_id])
  end

end
