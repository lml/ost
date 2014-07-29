# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  has_many :students, :dependent => :destroy
  has_one :researcher, :dependent => :destroy
  has_many :registration_requests, :dependent => :destroy
  has_many :course_instructors, :dependent => :destroy
  has_many :educators, :dependent => :destroy

  attr_accessor :email_confirmation
  
  attr_accessible :username, 
                  :email, :email_confirmation, 
                  :password, :password_confirmation, 
                  :remember_me,
                  :first_name, :last_name, :nickname, 
                  :time_zone, :terp_only
    
  validates_presence_of :first_name, :last_name, :username
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :username, :in => 3..40
  validates_format_of :username, :with => /\A[A-Za-z\d_]+\z/  # alphanum + _
  validate :validate_username_unchanged, :on => :update
  
  validates_confirmation_of :email, :if => Proc.new { |user| user.email_changed? }
  
  before_create :assign_research_id
  before_create :assign_education_id
  before_create :make_first_user_an_admin
  before_update :validate_at_least_one_admin

  def self.active_users; where{disabled_at == nil}; end

  def self.administrators; where{is_administrator == true}; end
  def self.non_administrators
    ids = administrators.collect{|u| u.id}
    where{id.not_in ids} 
  end

  def self.educators; joins{educators.user}; end
  def self.non_educators
    ids = educators.collect{|u| u.id}
    where{id.not_in ids} 
  end

  def self.researchers; joins{researcher.user}; end
  def self.non_researchers
    ids = researchers.collect{|u| u.id}
    where{id.not_in ids} 
  end

  def self.active_administrators; administrators.active_users; end
  def self.error_notice_recipients; active_administrators.where{receives_error_notices == true}; end

  def self.administrators_for_display
    User.administrators.uniq.sort_by{ |user| user.last_name.downcase }
  end

  def self.non_administrator_educators_for_display
    User.non_administrators.educators.uniq.sort_by{ |user| user.last_name.downcase }
  end

  def self.non_administrator_non_educator_researchers_for_display
    User.non_administrators.non_educators.researchers.uniq.sort_by{ |user| user.last_name.downcase }
  end

  def self.non_administrator_non_educator_non_researchers_for_display
    User.non_administrators.non_educators.non_researchers.uniq.sort_by{ |user| user.last_name.downcase }
  end

  def full_name
    first_name + " " + last_name  
  end

  def is_administrator?
    is_administrator
  end

  def is_disabled?
    !disabled_at.nil?
  end

  def receives_error_notices?
    receives_error_notices
  end

  def is_researcher?
    if cached_is_researcher == nil
      self.cached_is_researcher = !researcher.nil?
    end
    cached_is_researcher
  end

  def is_visitor?
    false
  end

  def disable!
    update_attribute(:disabled_at, Time.current)
  end

  def enable!
    update_attribute(:disabled_at, nil)
  end

  def is_anonymous?
    false
  end

  # # Can't destroy users
  # def destroy
  # end
  # 
  # # Can't delete users
  # def delete
  # end

  # Access control redirect methods

  def can_list?(klass)
    klass.can_be_listed_by?(self)
  end

  def can_read?(resource)
    resource.can_be_read_by?(self)
  end

  def can_create?(resource)
    resource.can_be_created_by?(self)
  end

  def can_update?(resource)
    resource.can_be_updated_by?(self)
  end

  def can_destroy?(resource)
    resource.can_be_destroyed_by?(self)
  end

  def can_vote_on?(resource)
    resource.can_be_voted_on_by?(self)
  end

  def can_sort?(resource)
    resource.can_be_sorted_by?(self)
  end

  def can_read_children?(resource, children_symbol)
    resource.children_can_be_read_by?(self, children_symbol)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => username.downcase }]).first
    else
      where(conditions).first
    end
  end

  def terp_confirmed?
    terp_confirmation_code.nil?
  end

private 

  attr_accessor :cached_is_researcher

  def assign_research_id
    assign_random_id(:research_id)
  end
  
  def assign_education_id
    assign_random_id(:education_id)
  end
  
  def assign_random_id(field)
    begin
      generated_id = SecureRandom.random_number(100000000)
    end while User.where(field => generated_id).any?
    self.send("#{field}=","%08d" % generated_id)
  end

  def make_first_user_an_admin
    if User.count == 0
      self.is_administrator = true
    end
  end

  def validate_username_unchanged
    return if username == username_was
    errors.add(:base, "Usernames cannot be changed.")
    false
  end

  def validate_at_least_one_admin
    only_one_active_admin = User.active_administrators.count == 1
    was_admin = is_administrator_was
    was_disabled = !disabled_at_was.nil?
    return if !only_one_active_admin ||
              was_disabled || !was_admin ||
              (is_administrator? && !is_disabled?)
    errors.add(:base, "There must have at least one admin.")
    false
  end

  def self.search(type, text)
    return User.where{id == nil}.where{id != nil} if text.blank? # Empty
    
    # Note: % is the wildcard. This allows the user to search
    # for stuff that "begins with" but not "ends with".
    case type
    when 'Name'
      u = User.scoped
      text.gsub(/[%,]/, '').split.each do |t|
        next if t.blank?
        query = t + '%'
        u = u.where{(first_name =~ query) | (last_name =~ query)}
      end
      return u
    when 'Email'
      query = text.gsub('%', '') + '%'
      return where{email =~ query}
    else # All
      u = User.scoped
      text.gsub(/[%,]/, '').split.each do |t|
        next if t.blank?
        query = t + '%'
        u = u.where{(first_name =~ query) | (last_name =~ query) |
                    (email =~ query)}
      end
      return u
    end
  end

end
