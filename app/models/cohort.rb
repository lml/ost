class Cohort < ActiveRecord::Base
  
  has_many :students, :dependent => :destroy
  
  attr_accessible :number, :section_id
end
