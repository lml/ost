# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

namespace :db do
  
  desc "Resets column information when for some reason Rails or Rake doesn't pick up migration changes"
  task :reset_column_information => :environment do
    ActiveRecord::Base.send(:subclasses).each do |model|
      model.reset_column_information
    end
  end

end