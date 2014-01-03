class ExternalAssignment < ActiveRecord::Base
  belongs_to :klass
  has_many :external_assignment_exercises,  dependent: :destroy
  has_many :student_external_assignments,   dependent: :destroy

  acts_as_numberable container: :klass

  attr_accessible :klass,
                  :external_assignment_exercises,
                  :student_external_assignments,
                  :name

  def add_missing_components
    add_missing_student_external_assignments
    add_missing_student_external_assignment_exercises
  end

  def add_missing_student_external_assignments
    students_in_klass    = klass.students
    students_with_sea    = student_external_assignments.collect{|sea| sea.student}
    students_without_sea = students_in_klass - students_with_sea

    students_without_sea.each do |student|
      logger.debug "adding SEA for Student #{student.id} to EA #{id}"
      student_external_assignments.create!(student: student)
    end
  end

  def add_missing_student_external_assignment_exercises
    students_in_klass = klass.students
    external_assignment_exercises.each do |eae|
      students_with_seae = eae.student_external_assignment_exercises.collect{|seae| seae.student_external_assignment.student}
      students_without_seae = students_in_klass - students_with_seae
      students_without_seae.each do |student|
        sea = student_external_assignments.where{student_id == my{student.id}}.first
        logger.debug "adding SEAE for Student #{student.id} to SEA #{sea.id} and EAE #{eae.id}"
        eae.student_external_assignment_exercises.create!(student_external_assignment: sea)
      end
    end
  end

  def can_be_read_by?(user)
    klass.is_educator?(user) || user.is_researcher? || user.is_administrator?
  end
    
  def can_be_created_by?(user)
    klass.is_teacher?(user) || user.is_administrator?
  end
  
  def can_be_updated_by?(user)
    klass.is_teacher?(user) || user.is_administrator?
  end
  
  def can_be_destroyed_by?(user)
    klass.is_teacher?(user) || user.is_administrator?
  end
  
  def can_be_sorted_by?(user)
    can_be_updated_by?(user)
  end

  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :external_assignment_exercises
      klass.is_educator?(user) || user.is_researcher? || user.is_administrator?
    end
  end

end
