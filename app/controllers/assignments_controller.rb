# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class AssignmentsController < ApplicationController

  before_filter :enable_timeout, :only => [:show]
  before_filter :enable_clock

  def show
    @assignment = Assignment.find(params[:id])

    raise SecurityTransgression unless present_user.can_read?(@assignment)

    student = @assignment.cohort.get_student(present_user)

    turn_on_consenting(student)

    if !student.nil?
      @student_assignment = StudentAssignment.for_student(student).for_assignment(@assignment)

      if @student_assignment.blank?
        @student_assignment = StudentAssignment.new(:student_id => student.id, 
                                                    :assignment_id => @assignment.id)

        raise SecurityTransgression unless present_user.can_create?(@student_assignment)

        # Normally, one wouldn't want to change the database in a GET call, but
        # this is just lazy-instantiation so it is OK.
        @student_assignment.save!
      else
        @student_assignment = @student_assignment.first
      end
    end    
  end

  def grades
    @assignment = Assignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read_children?(@assignment, :grades)
    respond_to do |format|
      format.xls
    end
  end

end
