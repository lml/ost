# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentPlan < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :assignments, :dependent => :destroy
  has_many :assignment_plan_topics, :dependent => :destroy
  has_many :topics, :through => :assignment_plan_topics
  belongs_to :section
  belongs_to :cohort

  acts_as_taggable

  before_save :add_new_exercise_tags

  before_destroy :destroyable?, prepend: true

  attr_accessible :introduction, :is_group_work_allowed, :is_open_book, 
                  :is_ready, :is_test, :learning_plan_id, :name, :learning_plan,
                  :starts_at, :ends_at, :section_id, :tag_list, :cohort_id

  attr_accessor   :new_exercise_tags
  attr_accessible :new_exercise_tags

  ##
  ## Start and end times
  ##

  validates :starts_at, :ends_at, :presence => true
  validates :ends_at, :date => {:after => :starts_at, :message => "End time must be after start time"}, :if => :starts_ends_at_present?
  validate :starts_ends_at_in_bounds, :if => :starts_ends_at_present?

  def starts_at=(timeOrTimestr)
    time = nil
    if timeOrTimestr.present?
      time = Chronic.parse(timeOrTimestr.to_s)
      time = time.change(:min => time.min - (time.min % 1))
      if learning_plan.present?
        time = TimeUtils.time_and_zone_to_utc_time(time, TimeUtils.zonestr_to_zone(learning_plan.klass.time_zone))
      end
    end
    write_attribute(:starts_at, time)
  end

  def ends_at=(timeOrTimestr)
    time = nil
    if timeOrTimestr.present?
      time = Chronic.parse(timeOrTimestr.to_s)
      time = time.change(:min => time.min - (time.min % 1))
      if learning_plan.present?
        time = TimeUtils.time_and_zone_to_utc_time(time, TimeUtils.zonestr_to_zone(learning_plan.klass.time_zone))
      end
    end
    write_attribute(:ends_at, time)
  end
  
  def starts_ends_at_present?
    starts_at.present? && ends_at.present?
  end

  def initialize_starts_ends_at
    return if starts_at.present? && ends_at.present?
    
    if learning_plan.present?
      initialize_starts_ends_at_from_learning_plan
    end
  end

  def initialize_starts_ends_at_from_learning_plan
    latest_end = peers.blank? ? nil : peers.collect{|p| p.ends_at}.max

    self.starts_at = latest_end.nil? ? learning_plan.klass.start_date : latest_end
    self.ends_at = self.starts_at + 7.days

    if self.ends_at > learning_plan.klass.end_date
      self.ends_at = learning_plan.klass.end_date
      self.starts_at = self.ends_at - 7.days
      
      if self.starts_at < learning_plan.klass.start_date
        self.starts_at = learning_plan.klass.start_date
      end
    end
  end

  def starts_ends_at_in_bounds
    errors.add(:base, "This assignment cannot start before its class starts.") \
      if starts_at < learning_plan.klass.start_date
    errors.add(:base, "This assignment cannot end after its class ends.") \
      if ends_at > learning_plan.klass.end_date
  end


  
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  validates :max_num_exercises, :allow_nil => true, :numericality => { :greater_than_or_equal_to => 0 }
  
  scope :non_tests, where(:is_test => false)
  scope :tests, where(:is_test => true)
  scope :not_assigned, joins{assignments.outer}.where{assignments.assignment_plan_id == nil}

  # To get around some scope issues having to do with when their guts are evaluated,
  # define those that depend on Time.now in class methods
  #
  # https://rails.lighthouseapp.com/projects/8994/tickets/4960-scopes-cached-in-production-mode
  # https://github.com/ernie/squeel/wiki/Common-issues
  
  def self.started;         where{starts_at.lt Time.now}; end
  def self.not_finished;    where{ends_at.gt Time.now}; end 
  def self.in_progress;     started.not_finished; end
  def self.can_be_assigned; not_assigned.in_progress.where{is_ready == true}; end
  
  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This assignment cannot be deleted because it has been assigned (except by admin override)") \
      if assigned?
    errors.none?
  end
  
  def assigned?
    assignments(true).any?
    # assignments.any?{|a| a.assigned?}
  end
  
  def active?
    Time.now > starts_at && Time.now < ends_at
  end
  
  def peers
    learning_plan.assignment_plans(true)
  end
  
  # The assignment that starts first is the first plan and has number 0, the one
  # that starts next is the second plan and has number 1, and so on.
  def number
    peers.index{|ap| ap.id == self.id}
  end

  def homework_number
    peers.non_tests.index{|ap| ap.id == self.id}
  end
  
  def predecessors
    AssignmentPlan.joins{learning_plan}
                  .where{learning_plan.id == my{learning_plan}.id}
                  .where{starts_at.lt my{starts_at}}
                  .order{starts_at.desc}
  end

  def self.build_and_distribute_assignments
    AssignmentPlan.can_be_assigned.each do |assignment_plan|
      if !assignment_plan.section_id.nil?
        cohorts = assignment_plan.section.cohorts
      else
        cohorts = !assignment_plan.cohort_id.nil? ?
                  [assignment_plan.cohort] :
                  assignment_plan.learning_plan.klass.cohorts
      end
      
      cohorts.each do |cohort|
        assignment = cohort.learning_condition.build_assignment(assignment_plan)
        assignment.save
      end
    end
  end
  
  # This method assumes the argument is a klass cohort
  def applies_to_klass_cohort?(cohort)
    if !section_id.nil?
      section.cohorts.where{id == cohort.id}.any?
    elsif !cohort_id.nil?
      cohort_id == cohort.id
    else
      true
    end
  end

  def add_new_exercise_tags
    return if new_exercise_tags.blank?

    assignments.find_each do |a|
      a.assignment_exercises.find_each do |ae|
        ae.tag_list.add new_exercise_tags, :parse => true
        ae.save!
      end
    end

    self.tag_list.add new_exercise_tags, :parse => true
    self.new_exercise_tags = ""
  end

  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    learning_plan.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
end
