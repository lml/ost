class ConsentForm < ActiveRecord::Base
  attr_accessible :esignature_required, :html, :name
end
