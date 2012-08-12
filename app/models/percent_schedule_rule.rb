class PercentScheduleRule
  include ActiveModel::Validations 
  
  attr_accessor :percent, :tags

  validates :percent, :presence => true, 
                      :numericality => {:greater_than_or_equal_to => 0, 
                                        :less_than_or_equal_to => 100}
  validate :tag_format_ok
                                       
  def initialize(attributes = {})  
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end  
  
protected

  def tag_format_ok
    tag_array = tags.split(",").collect{|t| t.strip}
    self.errors.add(:base, "Illegal label!") if tag_array.empty? && !tags.blank?
    self.errors.add(:base, "No empty labels are allowed") if tag_array.any?{|t| t.blank?}
    self.errors.add(:base, "Labels can only contain letters, numbers, underscores, hyphens, and spaces.") \
      if tag_array.any?{|tag| (tag =~ /^[A-Za-z_\d\- ]+$/).nil?}
  end
 
end