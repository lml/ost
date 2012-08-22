namespace :db do
  namespace :scenario do
  
    task :full_learning_plan, [:start_date] => ["db:drop", "db:migrate", "db:populate", :environment] do |t, args|
      args.with_defaults(:start_date => Time.now)
    
      FactoryGirl.create(:site_license)
      
      puts "Building organizations...\n"
      
      rice = FactoryGirl.create(:organization, :name => "Rice University", :default_time_zone => 'Central Time (US & Canada)')
      gatech = FactoryGirl.create(:organization, :name => "Georgia Tech", :default_time_zone => 'Eastern Time (US & Canada)')
    
      puts "Building Math 101 at Rice and setting Walter as its instructor...\n"
    
      math101 = FactoryGirl.create(:course, :name => 'MATH 101: Single-variable Calculus',
                                        :description => 'This course introduces math in the limit blah blah blah lorem ipsum ' + 
                                                        'cogito ergo sum I think therefore I am aren\'t I?  I think so anyway.  42.',
                                        :organization => rice)
                                            
      walter = User.find_by_username("walter")
      
      FactoryGirl.create(:course_instructor, :course => math101, :user => walter)
      
      klass = FactoryGirl.create(:klass, :creator => walter)

      learning_plan = klass.learning_plan
      
      exercise_urls = {0 => ["q561v2", "q562", "q435v1", "q528v1", "q107v0", "q124v0", "q125v0", "q305v1", "q311v1", "q319v1", "q321v1", "q329v1", "q330v1"],
                       1 => ["q462v1", "q448v1", "q535v1",  "q331v1", "q332v1", "q373v1", "q373v2", "q375v1", "q377v1", "q379v1", "q305v2", "q384v1", "q391v1", "q394v1", "q395v1", "q399v1"],
                       2 => ["q534v1", "q542v1", "q544v1", "q400v1", "q401v1", "q408v1", "q409v1", "q410v1", "q416v1", "q417v1", "q418v1", "q420v1", "q421v1", "q422v1", "q423v1", "q424v1"],
                       3 => ["q425v1", "q426v1", "q427v1", "q430v1", "q432v1", "q434v1", "q435v1", "q438v1", "q440v1", "q441v1", "q442v1", "q443v1", 
                             "q444v1", "q445v1", "q446v1", "q447v1", "q448v1", "q449v1", "q450v1", "q451v1", "q453v1", "q454v1", "q455v1", "q456v1", 
                             "q457v1", "q458v1", "q459v1", "q460v1", "q461v1", "q462v1", "q463v1", "q465v1", "q466v1", "q467v1", "q468v1", "q470v1"]}
                       
                       
                
      resource_urls = {0 => %w(m0001 m0002 m0003),
                       1 => %w(m0081 m0004 m0008),
                       2 => %w(m0011 m0012 m0013),
                       3 => %w(m0020 m0023)}
 
   
      puts "Building topics... (may take a while as all exercise URLs are verified)\n"
      
      old_url_existence_flag = Ost::Application.config.enable_url_existence_validations
      Ost::Application.config.enable_url_existence_validations = false
      
      ["Signal Basics", "CT Signals", "CT Systems", "DT Signals"].each_with_index do |name, tt|
        topic = FactoryGirl.create(:topic, :name => name, :learning_plan => learning_plan)
        # debugger
        resource_urls[tt].each do |url|
          FactoryGirl.create(:resource, :url => "http://cnx.org/content/#{url}/latest", :topic => topic, :name => "")        
        end 
        
        urls = exercise_urls[tt]
        
        urls.each do |url|
          te = TopicExercise.new(:topic => topic)
          te.update_url!("http://quadbase.org/questions/#{url}")          
        end
      end
      
      Ost::Application.config.enable_url_existence_validations = old_url_existence_flag
      
      puts "Building assignment plans (shown as 'assignments' to user)...\n"
      
      3.times do |n|
        assignment_plan = FactoryGirl.create(:assignment_plan, :learning_plan => learning_plan, :is_ready => true, :starts_at => nil, :ends_at => nil)
        assignment_plan.topics << learning_plan.topics[n]
        assignment_plan.save
      end
      
      puts "Building the learning condition...\n"
      
      FactoryGirl.create(:cohort, :klass => klass)

      schedules_by_cohort = [
        # Cohort 1
        [
          [{:percent => 50, :tags => "E1, SPACED"}, {:percent => 50, :tags => "E2, SPACED"}],
          [{:percent => 100, :tags => "E1, MASSED"}]
        ],
        # Cohort 2
        [
          [{:percent => 100, :tags => "E1, MASSED"}],
          [{:percent => 50, :tags => "E1, SPACED"}, {:percent => 50, :tags => "E2, SPACED"}]
        ]
      ]

      klass.cohorts(true).each_with_index do |cohort,cc|
        PercentScheduler.create(:learning_condition => cohort.learning_condition, :schedules => schedules_by_cohort[cc] )
      end
      
      puts "Setting Eve as a researcher...\n"
    
      FactoryGirl.create(:researcher, :user => User.find_by_username("eve"))
      
      puts "Adding students (Alice in Cohort 1, Bob in Cohort 2)...\n"

      FactoryGirl.create(:student, :user => User.find_by_username("alice"), 
                                   :section => klass.sections.first, :cohort => klass.cohorts.first)
      FactoryGirl.create(:student, :user => User.find_by_username("bob"), 
                                   :section => klass.sections.first, :cohort => klass.cohorts.last)
      
    end

  end
end
