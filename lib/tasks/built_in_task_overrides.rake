# This snippet comes from:
#   ~/.rvm/gems/ruby-1.9.3-p194@ost/gems/activerecord-3.2.8/lib/active_record/railties/databases.rake
# and is used by certain built-in rake tasks.  It causes db:drop to normally 
# delete both the development and test databases, which is not desireable from
# a cucumber test scenario POV, so it has been changed here. 
def configs_for_environment
  environments = [Rails.env]
  #environments << 'test' if Rails.env.development?
  ActiveRecord::Base.configurations.values_at(*environments).compact.reject { |config| config['database'].blank? }
end
