class Resource < ActiveRecord::Base
  attr_accessible :name, :notes, :number, :resourceable_id, :resourceable_type, :url
end
