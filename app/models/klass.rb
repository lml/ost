# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class Klass < ActiveRecord::Base
  belongs_to :course
  has_one :consent_options, :as => :consent_optionable, :dependent => :destroy
  has_one :learning_plan, :dependent => :destroy
  has_many :sections,   :dependent => :destroy
  has_many :cohorts,    :dependent => :destroy, :order => :number
  has_many :external_assignments, :dependent => :destroy, :order => :number

  has_many :educators,  :dependent => :destroy

  validates :open_date,   :presence => true
  validates :start_date,  :presence => true, :date => {:after => :open_date}
  validates :end_date,    :presence => true, :date => {:after => :start_date}
  validates :close_date,  :presence => true, :date => {:after => :end_date}

  validates :course_id, :presence => true
  validates :time_zone, :presence => true
  validate :is_controlled_experiment_change_ok?, :on => :update

  before_destroy :destroyable?, prepend: true
  before_create :set_first_instructor
  before_create :init_learning_plan
  before_create :init_first_section
  before_create :init_first_cohort
  before_create :init_consent_options

  attr_accessor :source_learning_plan_id, :creator, :enable_admin_controls

  attr_accessible :open_date, :close_date, :start_date, :end_date, 
                  :approved_emails, :time_zone, 
                  :source_learning_plan_id, :is_controlled_experiment,
                  :allow_student_specified_id, :enable_assignment_by_cohort
  
  def self.opened;  where{open_date.lte  Time.now}; end 
  def self.started; where{start_date.lte Time.now}; end 
  def self.ended;   where{end_date.lte   Time.now}; end
  def self.closed;  where{close_date.lte Time.now}; end

  def self.not_opened;  where{open_date.gt  Time.now}; end 
  def self.not_started; where{start_date.gt Time.now}; end 
  def self.not_ended;   where{end_date.gt   Time.now}; end
  def self.not_closed;  where{close_date.gt Time.now}; end

  def self.current;     opened.not_closed; end
  def self.not_current; where{ (open_date.gt Time.now) | (close_date.lte Time.now) }; end

  def self.in_progress;     started.not_ended; end
  def self.not_in_progress; where{ (start_date.gt Time.now) | (end_date.lte Time.now) }; end

  def open_date=(timeOrTimestr)
    time = nil
    if timeOrTimestr.present?
      time = Chronic.parse(timeOrTimestr.to_s)
      time = time.change(:min => time.min - (time.min % 1))
      if learning_plan.present?
        time = TimeUtils.time_and_zone_to_utc_time(time, TimeUtils.zonestr_to_zone(time_zone))
      end
    end
    write_attribute(:open_date, time)
  end

  def start_date=(timeOrTimestr)
    time = nil
    if timeOrTimestr.present?
      time = Chronic.parse(timeOrTimestr.to_s)
      time = time.change(:min => time.min - (time.min % 1))
      if learning_plan.present?
        time = TimeUtils.time_and_zone_to_utc_time(time, TimeUtils.zonestr_to_zone(time_zone))
      end
    end
    write_attribute(:start_date, time)
  end

  def end_date=(timeOrTimestr)
    time = nil
    if timeOrTimestr.present?
      time = Chronic.parse(timeOrTimestr.to_s)
      time = time.change(:min => time.min - (time.min % 1))
      if learning_plan.present?
        time = TimeUtils.time_and_zone_to_utc_time(time, TimeUtils.zonestr_to_zone(time_zone))
      end
    end
    write_attribute(:end_date, time)
  end
  
  def close_date=(timeOrTimestr)
    time = nil
    if timeOrTimestr.present?
      time = Chronic.parse(timeOrTimestr.to_s)
      time = time.change(:min => time.min - (time.min % 1))
      if learning_plan.present?
        time = TimeUtils.time_and_zone_to_utc_time(time, TimeUtils.zonestr_to_zone(time_zone))
      end
    end
    write_attribute(:close_date, time)
  end

  def name
    course.name
  end
  
  def opened?
    Time.now >= open_date
  end

  def started?
    Time.now >= start_date
  end
  
  def ended?
    Time.now > end_date
  end
  
  def closed?
    Time.now > close_date
  end

  def current?
    !past? && !future?
  end  

  def past?
    ended?
  end

  def future?
    !opened?
  end

  def not_opened?
    !opened?
  end

  def in_progress?
    started? && !ended?
  end  

  def registration_requests
    RegistrationRequest.joins{section.klass}.where{section.klass.id == my{id}}
  end
  
  def is_preapproved?(user)
    return true if is_teacher?(user)

    approved_emails_array = (approved_emails || '').split("\n").collect{|ae| ae.strip}

    approved_emails_array.any? do |ae|
      user.email.downcase == ae.downcase || 
      user.email.downcase.match(ae.downcase)
    end
  end

  def enable_assignments_by_cohorts?
    enable_assignment_by_cohort
  end

  def is_educator?(user)
    educators.any?{|e| e.user_id == user.id}
  end

  def is_teacher?(user)
    is_instructor?(user) || is_teaching_assistant?(user)
  end

  def is_instructor?(user)  # TODO change all of these to use Squeel
    educators.any?{|e| e.user_id == user.id && e.is_instructor}
  end

  def is_teaching_assistant?(user)
    educators.any?{|e| e.user_id == user.id && (e.is_instructor || e.is_teaching_assistant)}
  end

  def is_grader?(user)
    educators.any?{|e| e.user_id == user.id && (e.is_instructor || e.is_teaching_assistant || e.is_grader)}
  end
  
  def is_student?(user)
    query_student_for(user).any?
  end
  
  def is_active_student?(user)
    query_student_for(user).active.any?
  end
  
  def student_for(user)
    query_student_for(user).first
  end

  def students
    Student.joins{section.klass}.where{section.klass.id == my{id}}
  end
  
  # The returned student scope can include dropped students
  def query_student_for(a_user)
    Student.joins{section.klass}
           .joins{:user}
           .where{(section.klass.id == my{id})}
           .where{(user.id == a_user.id)}
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
    is_teacher?(user) || user.is_administrator?
  end

  def can_be_destroyed_by?(user)
    is_teacher?(user) || user.is_administrator?
  end
  
  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :sections
      is_educator?(user) || user.is_administrator?
    when :cohorts
      (is_controlled_experiment ? Researcher.is_one?(user) : is_teaching_assistant?(user)) || user.is_administrator?
    when :learning_conditions # not a direct child
      (is_controlled_experiment ? Researcher.is_one?(user) : is_instructor?(user)) || user.is_administrator?
    when :students
      is_educator?(user) || user.is_researcher? || user.is_administrator?
    when :report
      is_teacher?(user) || user.is_researcher? || user.is_administrator?
    when :external_assignments_report
      is_teacher?(user) || user.is_researcher? || user.is_administrator?
    when :class_grades
      is_educator?(user) || user.is_researcher? || user.is_administrator?
    when :analytics 
      is_teacher?(user) || is_student?(user) || user.is_administrator?
    when :management_overview
      user.is_researcher? || user.is_administrator?
    when :external_assignments
      is_teacher?(user) || user.is_researcher? || user.is_administrator?
    end
  end

protected

  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This class cannot be deleted because it has sections (except by admin override).") if sections(true).any?
    errors.none?
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
  
  def init_first_cohort
    self.cohorts << Cohort.new
  end
  
  def init_consent_options
    self.consent_options = ConsentOptions.new
  end
  
  def is_controlled_experiment_change_ok?
    errors.add(:is_controlled_experiment, "can only be changed by an administrator.") \
      if is_controlled_experiment_was != is_controlled_experiment && !enable_admin_controls
    errors.none?
  end

end
