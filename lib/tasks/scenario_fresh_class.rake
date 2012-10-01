namespace :db do
  namespace :scenario do
  
    task :fresh_class, [:start_date] => ["db:drop", "db:migrate", "db:populate", :environment] do |t, args|
      # ensure that the non-cucumber FactoryGirl factories are loaded
      Dir[Rails.root.join("test", "jp_factories", "*.rb")].each {|file| require file }

      args.with_defaults(:start_date => Time.now)
      
      FactoryGirl.create(:site_license)
    
      rice = Factory.create(:organization, :name => "Rice University", :default_time_zone => 'Central Time (US & Canada)')
      gatech = Factory.create(:organization, :name => "Georgia Tech", :default_time_zone => 'Eastern Time (US & Canada)')
    
      math101 = Factory.create(:course, :name => 'MATH 101: Single-variable Calculus',
                                        :description => 'This course introduces math in the limit blah blah blah lorem ipsum ' + 
                                                        'cogito ergo sum I think therefore I am aren\'t I?  I think so anyway.  42.',
                                        :organization => rice)
                                            
      Factory.create(:course_instructor, :course => math101, :user => User.find_by_username("walter"))
    
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
