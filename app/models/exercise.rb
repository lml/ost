require 'open-uri'
require 'json'

class Exercise < ActiveRecord::Base
  has_many :topic_exercises, :dependent => :destroy
  
  before_validation :cleanup_url
  
  validates :url, :presence => true,
                  :uniqueness => true,
                  :url_format => true,
                  :url_existence => true
                  
  validate :can_get_content?
  
  attr_accessible :content_cache, :is_dynamic, :url
  
  def self.new_or_existing(url)
    existing = Exercise.find_by_url(url)
    existing.nil? ? Exercise.new(:url => url) : existing
  end
  
  # Check to see if this exercise is an orphan.  If so, delete
  def destroy_if_orphan!
    self.destroy if topic_exercises(true).empty?    
  end
  
  def clear_content_cache!
    self.update_attribute(:content_cache, nil)
  end
  
  def content
    if json_cache.nil?
      self.update_attribute(:content_cache, open(url+".json").read) if self.content_cache.nil?
      self.json_cache = JSON.parse(content_cache)
    end
    json_cache
  end
  
  def solutions_content
    JSON.parse(open(url+"/solutions.json").read)
  end
  
  def get_credit(choice_index)
    content["simple_question"]["answer_choices"][choice_index]["credit"]
  end
  
  def correct_choice_index
    content["simple_question"]["answer_choices"].index{|ac| ac["credit"] == 1}
  end
  
  def num_choices
    content["simple_question"]["answer_choices"].count
  end
  
  def quadbase_id
    url.split("/").last
  end
  
protected

  attr_accessor :json_cache

  def cleanup_url
    self.url = url.sub(/(\/)+$/,'').sub(/^https/,'http')
  end

  def destroyable?
    return true if WebsiteConfiguration.get_value(:sudo_enabled)
    errors.add(:base, "Cannot delete an exercise that has been assigned.") \
      if topic_exercises.any?{|te| te.assigned?}
    errors.empty?
  end

  def can_get_content?
    return true if Rails.env.test?
    begin
      content
    rescue Exception
      errors.add(:url, "does not point to anything we can retrieve.")
    end
    errors.empty?
  end
end
