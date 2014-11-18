# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StudentAssignment < ActiveRecord::Base
  
  require 'enum'
  
  belongs_to :assignment
  belongs_to :student
  has_many :student_exercises, :dependent => :destroy
  has_many :response_times, :as => :response_timeable, :dependent => :destroy, :order => :created_at
  has_many :assignment_coworkers, :dependent => :destroy
  
  attr_accessible :assignment_id, :student_id
  
  validates :assignment_id, :presence => true
  validates :student_id, :presence => true, :uniqueness => {:scope => :assignment_id}

  after_create :create_student_exercises
  before_destroy :destroyable?, prepend: true

  # Realized a little late in the game that it is bad when these numbers are the same as
  # the Event enum numbers in student exercise, so made them different
  class Event < Enum
    DUE = 100
    COMPLETE = 101 
  end
  
  scope :visible, lambda { |user| 
    if user.is_researcher? || user.is_visitor?
      joins{student.consent}.where{student.consent.did_consent == true}
    else
      scoped
    end
  }

  scope :for_report, -> { includes({:student => [:section, :cohort, :user]}, {:student_exercises => [{:assignment_exercise => {:taggings => :tag}}, :free_responses]}, :assignment_coworkers) }

  def assignment_has_exercises?
    errors.add(:assignment, "doesn't have any exercises.") \
      if assignment(true).assignment_exercises.empty?
    errors.empty?
  end

  scope :for_student, lambda {|student| 
    where{student_id == student.id} unless student.nil?
  }             
  scope :for_assignment, lambda {|assignment| 
    where{assignment_id == assignment.id} unless assignment.nil?
  }

  def started?
    !started_at.nil?
  end

  def completed?
    !completed_at.nil?
  end
  
  def is_coworker?(user)
    assignment_coworkers.includes(:student).any?{|cw| cw.student.user_id == user.id}
  end

  def ordered_student_exercises
    student_exercises.joins{assignment_exercise}.order{assignment_exercise.number}
  end
  
  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This student assignment cannot be destroyed (except by admin override)")
    errors.none?
  end

  def mark_started_if_indicated!
    if self.started_at.nil?
      self.started_at = Time.now
      self.save!
    end
  end

  def mark_complete_if_indicated!
    if student_exercises.where{selected_answer_submitted_at == nil}.none?
      self.completed_at = Time.now
      self.save!
      notify_observers(:complete)
    end
  end
  
  def mark_observed_due!(time)
    self.observed_due_at = time
    self.save!
    notify_observers(:due)
  end
  
  # Checks for student assignments that have just become due, marks them as having
  # been observed as due, and notifies any observers.
  def self.note_if_due!
    observation_time = Time.now
    
    due_sa_ids = StudentAssignment.joins{assignment.assignment_plan}
                                  .where{assignment.assignment_plan.ends_at.lt observation_time}
                                  .where{observed_due_at == nil}.collect{|sa| sa.id}
    
    # Doing this find instead of using the query results above so we avoid
    # an activerecord readonly error                              
    due_sas = StudentAssignment.find(due_sa_ids)
                               
    due_sas.each do |due_sa| 
      begin
        due_sa.mark_observed_due!(observation_time)
      rescue Exception => e
        DeveloperNotifier.exception_email(e, nil, "An error occurred in StudentAssignment#mark_observed_due! on SA id=#{due_sa.id}")
      end
    end
  end
  
  def learning_condition
    LearningCondition.joins{cohort.students.student_assignments}
                     .where{cohort.students.student_assignments.id == my{id}}
                     .first
  end
  
  def score
    ses = student_exercises.to_a.select{ |se| !se.topic.is_survey }
    score = ses.inject(0.0) { |score, se| score += se.score }
    score /= ses.size if ses.size > 0
  end
  
  def show_correctness_feedback?
    learning_condition.show_correctness_feedback?(self)
  end

  #############################################################################
  # Access control methods
  #############################################################################
      
  def can_be_read_by?(user)
    !user.is_anonymous? && (student.section.klass.is_educator?(user) || (user.is_researcher? && student.consented?)) || user.is_administrator?
  end
      
  def can_be_created_by?(user)
    !user.is_anonymous? && user.id == student.user.id
  end
    
protected

  def create_student_exercises
    assignment.assignment_exercises.each do |assignment_exercise|
      student_exercise = StudentExercise.new
      # student_exercise.student = student
      student_exercise.assignment_exercise = assignment_exercise
      student_exercise.student_assignment = self
      student_exercise.save!
    end
  end

end
