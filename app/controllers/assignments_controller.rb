# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class AssignmentsController < ApplicationController

  before_filter :enable_timeout, :only => [:show]
  before_filter :enable_clock

  def show
    @assignment = Assignment.find(params[:id])

    raise SecurityTransgression unless present_user.can_read?(@assignment)

    student = @assignment.get_student(present_user)

    turn_on_consenting(student)

    if !student.nil?
      @student_assignment = StudentAssignment.for_student(student).for_assignment(@assignment).first
    end    
    @include_mathjax = view_context.authority?
  end

  def grades
    @assignment = Assignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read_children?(@assignment, :grades)
    respond_to do |format|
      format.xls
    end
  end

end
