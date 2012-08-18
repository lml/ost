class StudentAssignment < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :student
  has_many :student_exercises, :dependent => :destroy
  has_many :response_times, :as => :response_timeable, :dependent => :destroy, :order => :created_at
  has_many :assignment_coworkers, :dependent => :destroy
  
  attr_accessible :assignment_id, :student_id
  
  validates :assignment_id, :presence => true
  validates :student_id, :presence => true, :uniqueness => {:scope => :assignment_id}

  validate :assignment_has_exercises?, :on => :create

  after_create :create_student_exercises
  before_destroy :destroyable?

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
  
  def is_coworker?(user)
    assignment_coworkers.includes(:student).any?{|cw| cw.student.user_id == user.id}
  end
  
  def destroyable?
    raise NotYetImplemented
  end
  
  def mark_complete_if_indicated!
    if student_exercises.where{selected_answer_submitted_at == nil}.none?
      self.completed_at = Time.now
      self.save!
    end
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
      
  def can_be_read_by?(user)
    !user.is_anonymous? && (student.section.klass.is_educator?(user) || (user.is_researcher? && student.consented?))
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
