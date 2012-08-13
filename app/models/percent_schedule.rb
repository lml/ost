class PercentSchedule
  include ActiveModel::Validations 
  
  attr_accessor :rules
  
  validate :rules_ok
  
  def initialize(schedule)
    @rules ||= []
    schedule.each do |rule|
      @rules.push(PercentScheduleRule.new(rule))
    end
  end
  
  def rules_ok
    @rules.each_with_index do |rule, index|
      if !rule.valid?
        rule.errors.full_messages.each do |msg|
          self.errors.add(:base, msg)
        end
      end
    end
    errors.any?
  end
end
