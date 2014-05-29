# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.


class AssignmentExercisesController < ApplicationController

  def show
    @assignment_exercises = AssignmentExercise.find(params[:id]).topic_exercise.assignment_exercises
    raise SecurityTransgression unless present_user.can_read?(@assignment_exercises.first)
    @include_mathjax = true
  end

end
