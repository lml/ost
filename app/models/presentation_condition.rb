# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class PresentationCondition < ActiveRecord::Base
  store                :settings
  store_accessor       :settings, :label_regex
  store_typed_accessor :settings, :boolean, :requires_free_response
  store_typed_accessor :settings, :boolean, :requires_selected_answer

  after_initialize  :supply_missing_values

  attr_accessible :label_regex,
                  :requires_free_response, :requires_selected_answer,
                  :follow_up_question, :apply_follow_up_question_to_tests

  def self.standard_practice_presentation_condition
    PresentationCondition.new(:label_regex              => 'standard practice',
                              :requires_free_response   => true,
                              :requires_selected_answer => true)
  end

  def self.default_presentation_condition
    PresentationCondition.new(:label_regex              => '.*',
                              :requires_free_response   => true,
                              :requires_selected_answer => true)
  end

  def applies_to?(student_or_assignment_exercise)
    label_regex_array = label_regex.split(",").collect{|lr| lr.strip}

    if student_or_assignment_exercise.instance_of? StudentExercise
      assignment_exercise = student_or_assignment_exercise.assignment_exercise
    else
      assignment_exercise = student_or_assignment_exercise
    end

    labels = assignment_exercise.tag_list

    label_regex_array.any? do |regex|
      labels.any? do |label|
        label == regex || label.match(Regexp.new(regex, Regexp::IGNORECASE))
      end
    end
  end

  def requires_free_response?
    requires_free_response
  end

  def requires_selected_answer?
    requires_selected_answer
  end

  def requires_follow_up_question?(student_exercise)
    return false if !follow_up_question.present?
    return apply_follow_up_question_to_tests? if student_exercise.is_test?
    return true
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    can_anything?(user)
  end

  def can_be_created_by?(user)
    can_anything?(user)
  end

  def can_be_updated_by?(user)
    can_anything?(user)
  end

  def can_be_destroyed_by?(user)
    can_anything?(user)
  end
  
  def can_be_sorted_by?(user)
    can_anything?(user)
  end
  
  def can_anything?(user)
    learning_condition.can_anything?(user)
  end

protected

  def supply_missing_values
    self.label_regex              = '.*' if label_regex.nil?
    self.requires_free_response   = true if requires_free_response.nil?
    self.requires_selected_answer = true if requires_selected_answer.nil?
    true
  end

end
