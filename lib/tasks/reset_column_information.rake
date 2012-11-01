namespace :db do
  
  desc "Resets column information when for some reason Rails or Rake doesn't pick up migration changes"
  task :reset_column_information => :environment do
    ActiveRecord::Base.send(:subclasses).each do |model|
      model.reset_column_information
    end
  end

end