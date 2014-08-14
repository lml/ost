# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class AssignmentsController < ApplicationController

  before_filter :enable_timeout, :only => [:show]
  before_filter :enable_clock

  def show
    @assignment = Assignment.find(params[:id])

    student = @assignment.get_student(present_user)

    raise SecurityTransgression unless present_user.can_read?(@assignment) || student.terp_only

    turn_on_consenting(student)

    if !student.nil?
      @student_assignment = StudentAssignment.for_student(student).for_assignment(@assignment).first
    end    

    @authority = @assignment.cohort.klass.is_educator?(present_user) ||
                 Researcher.is_one?(present_user) ||
                 present_user.is_administrator?
    @include_mathjax = @authority
  end

  def grades
    @assignment = Assignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read_children?(@assignment, :grades)
    respond_to do |format|
      format.xls
    end
  end

end
