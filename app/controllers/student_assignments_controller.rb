# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class StudentAssignmentsController < ApplicationController
  before_filter :get_student, :only => [:index]

  def index
    raise SecurityTransgression unless present_user.can_read?(@student, :student_assignments)
    @student_assignments = @student.student_assignments
  end

  def show
    @student_assignment = StudentAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@student_assignment)
    @include_mathjax = true
  end

  def create
    @student_assignment = StudentAssignment.new(params[:student_assignment])

    raise SecurityTransgression unless present_user.can_create?(@student_assignment)

    respond_to do |format|
      if @student_assignment.save
        format.html { redirect_to(@student_assignment.exercise_responses.first) }
      else
        @errors = @student_assignment.errors
        format.html { redirect_to request.referer }
      end
    end
  end

protected

  def get_student
    @student = Student.find(params[:student_id])
  end
end
