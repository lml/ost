class OfferedCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :consent_form
  has_one :learning_plan, :as => :learning_plannable, :dependent => :destroy
  has_many :sections, :dependent => :destroy
  has_many :educators, :dependent => :destroy
    
  validates :start_date, :presence => true
  validates :end_date, :presence => true, :date => {:after => :start_date}
  validates :course_id, :presence => true
  validates :time_zone, :presence => true

  before_destroy :destroyable?
  before_create :set_first_instructor
  before_create :init_learning_plan
  before_create :init_first_section
  
  attr_accessor :source_learning_plan_id, :creator
  
  attr_accessible :start_date, :end_date, :approved_emails, :time_zone, :source_learning_plan_id
  
  def is_preapproved?(user)
    approved_emails_array = (approved_emails || '').split("\n").collect{|ae| ae.strip}
    
    approved_emails_array.any? do |ae|
      user.email.downcase == ae.downcase || 
      user.email.downcase.match(ae.downcase)
    end
  end
  
  def is_educator?(user)
    educators.any?{|e| e.user_id == user.id}
  end
  
  def is_instructor?(user)  # TODO change all of these to use where
    educators.any?{|e| e.user_id == user.id && e.is_instructor}
  end
  
  def is_ta?(user)
    educators.any?{|e| e.user_id == user.id && (e.is_instructor || e.is_ta)}
  end

  def is_grader?(user)
    educators.any?{|e| e.user_id == user.id && (e.is_instructor || e.is_ta || e.is_grader)}
  end

  
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    true
  end
    
  def can_be_created_by?(user)
    course.is_instructor?(user) || user.is_administrator?
  end
  
  def can_be_updated_by?(user)
    is_educator?(user) || user.is_administrator?
  end
  
  def can_be_destroyed_by?(user)
    is_educator?(user) || user.is_administrator?
  end
  
protected

  def destroyable?
    return true if sections.empty? || sudo_enabled?
    errors.add(:base, "This offered course cannot be deleted because it has sections.")
    false
  end
  
  def set_first_instructor
    return if creator.nil? || creator.is_anonymous?
    self.educators << Educator.new(:user => creator, :is_instructor => true)
  end
  
  def init_learning_plan
    raise NotYetImplemented if !source_learning_plan_id.nil?
    self.learning_plan = LearningPlan.new({:name => "#{course.name} (#{Time.zone.now.strftime('%b %Y')})"})
  end
  
  def init_first_section
    self.sections << Section.new(:name => "Main")
  end
  
end