namespace :db do
  namespace :scenario do
  
    task :full_learning_plan, [:start_date] => ["db:drop", "db:migrate", "db:populate", :environment] do |t, args|
      args.with_defaults(:start_date => Time.now)
    
      rice = FactoryGirl.create(:organization, :name => "Rice University", :default_time_zone => 'Central Time (US & Canada)')
      gatech = FactoryGirl.create(:organization, :name => "Georgia Tech", :default_time_zone => 'Eastern Time (US & Canada)')
    
      math101 = FactoryGirl.create(:course, :name => 'MATH 101: Single-variable Calculus',
                                        :description => 'This course introduces math in the limit blah blah blah lorem ipsum ' + 
                                                        'cogito ergo sum I think therefore I am aren\'t I?  I think so anyway.  42.',
                                        :organization => rice)
                                            
      walter = User.find_by_username("walter")
      
      FactoryGirl.create(:researcher, :user => User.find_by_username("eve"))
      
      FactoryGirl.create(:course_instructor, :course => math101, :user => walter)
      
      klass = FactoryGirl.create(:klass, :creator => walter)
      # learning_condition = klass.learning_condition
      learning_plan = klass.learning_plan
      
      # PercentScheduler.create(:learning_condition => learning_condition)
      
      
      # FactoryGirl.create(:topic, :learning_plan => learning_plan)
      
      
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
      
    
      # 4.times{Factory.create(:concept)}
      #  
      #  course = Factory.create(:course, :name => "ELEC 301 Signals \& Systems",
      #                          :description => "This course introduces the notion of signal processing, " + 
      #                                          "and deals with signals, systems, and transforms, from " + 
      #                                          "their theoretical mathematical foundations to practical " + 
      #                                          "implementation in circuits, computer software and hardware. " + 
      #                                          "ELEC 301 acts as a bridge between the introductory ELEC 241/2 " + 
      #                                          "and more advanced courses such as ELEC 302, 303, 430, 431, " + 
      #                                          "437, 439.")
      #  section = Factory.create(:section, :title => "Fall 2011", :course => course, :start_date => args.start_date)
      #  
      #  educator = Factory.create(:educator, :user => User.find_by_username("prof"), :section => section)
      # 
      #  student = Factory.create(:student, :user => User.find_by_username("student"), :section => section)
      #  
      #  Factory.create(:student, :user => User.find_by_username("alice"), :section => section)
      #  
      #  Factory.create(:registration_request, :user => User.find_by_username("carlos"), :section => section)
      #  
      #  quadbase_urls = {1 => {0 => ["q561v2", "q562"], 1 => ["q435v1"], 2 => ["q528v1"]},
      #                   2 => {0 => ["q462v1"], 1 => ["q448v1"], 2 => ["q535v1"]},
      #                   3 => {0 => ["q534v1"], 1 => ["q542v1"], 2 => ["q544v1"]},
      #                   4 => {0 => [], 1 => [], 2 => []}}
      #                   
      #  resource_urls = {1 => %w(m0001 m0002 m0003),
      #                   2 => %w(m0081 m0004 m0008),
      #                   3 => %w(m0011 m0012 m0013),
      #                   4 => %w(m0020 m0023)}
      #    
      #      
      #  ["Signal Basics", "CT Signals", "CT Systems", "DT Signals"].each do |title|
      #    lesson = Factory.create(:lesson, :title => title, :course => course)
      # 
      #    resource_urls[lesson.number].each do |url|
      #      Factory.create(:resource, :url => "http://cnx.org/content/#{url}/latest", :lesson => lesson, :title => "")        
      #    end
      # 
      #    (0..2).each do |set_number|
      #      urls = quadbase_urls[lesson.number][set_number]
      #      
      #      urls.each do |url|
      #        le = LessonExercise.new
      #        le.lesson_exercise_set = lesson.lesson_exercise_sets[set_number]
      #        le.update_url!("http://quadbase.org/questions/#{url}")
      #        le.save                 
      #      end
      #    end
      #  end
    
    end

  end
end
