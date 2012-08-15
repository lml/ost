Ost::Application.routes.draw do

  # resources :consent_forms
  # 
  # resources :organization_managers
  # 

  get "admin", :to => 'admin#index'
  put "admin/cron", :to => 'admin#cron', :as => "cron"



  get "catalog", :to => 'catalog#index'

  resources :organizations do
    resources :courses, :shallow => true
  end
  
  resources :courses, :only => [] do
    resources :course_instructors, :shallow => true, :only => [:new, :create, :destroy] do
      collection do
        post 'search'
      end
    end
    
    # resources :offered_courses, :shallow => true, :except => [:index]
    resources :classes, :as => 'klasses', :shallow => true, :except => [:index]
  end
  
  resources :classes, :as => 'klasses', :only => [:index] do
    resources :educators, :shallow => true, :only => [:new, :create, :destroy, :show, :edit, :update] do
      collection do
        post 'search_instructors' => 'educators#search', :type => 'instructor'
        post 'search_graders' => 'educators#search', :type => 'grader'
        post 'search_assistants' => 'educators#search', :type => 'teaching_assistant'
      end
    end
    resources :students, :shallow => true, :only => [:index, :show, :update]    
    resources :sections, :shallow => true
    resources :registration_requests, :shallow => true, :only => [:new, :index]
    resources :learning_conditions, :shallow => true, :only => [:index]
    resources :cohorts, :shallow => true
    get 'preview_assignments', :on => :member
  end
  
  resources :learning_conditions, :only => [] do
    resources :schedulers, :shallow => true, :except => [:index, :show, :destroy]
  end
  
  resources :percent_schedulers, :only => [] do
    post 'add_schedule'
    post 'add_schedule_row'
    delete 'pop_schedule_row'
  end
  
  resources :students, :only => [] do
    put 'drop', :on => :member
  end
  
  resources :registration_requests, :except => [:new, :index] do 
    put 'approve', :as => "approve", :on => :member
    put 'reject', :as => "reject", :on => :member
  end
      
  resources :learning_plans, :only => [:show] do
    resources :topics, :shallow => true, :except => [:index, :show]
    resources :assignment_plans, :shallow => true
    resources :concepts, :shallow => true do
      post 'sort', :on => :collection
    end
  end
  
  resources :assignment_plans do
    resources :assignment_plan_topics, :shallow => true, :only => [:new, :create, :destroy]
  end
  
  resources :assignments, :only => [:show]
  
  resources :topics, :only => [] do
    resources :resources, :shallow => true, :except => [:index, :show] do
      post 'sort', :on => :collection
    end
    resources :topic_exercises, :shallow => true, :except => [:index, :show] do
      post 'sort', :on => :collection
    end
  end
    
  resources :response_times, :only => [:create]

  resources :student_assignments, :only => [:show, :create] do
    resources :assignment_coworkers, :shallow => true, :only => [:new, :create, :destroy] do
      collection do
        post 'search'
      end
    end
  end
  
  resources :student, :only => [] do
    resources :student_assignments, :only => [:index]
    resources :consents, :shallow => true, :except => [:edit, :update, :destroy]
  end

  resources :student_exercises, :only => [:show, :update] do
    get 'preview_free_response'
    get 'feedback'
    put 'make_correct'
  end
  
  # For users, we mix devise with our own users controller.  We have overriden
  # some devise controller methods, so point that out here.
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users, :only => [:index, :show, :edit, :update] do
    post 'become'
  end

  post "write", :to => 'write#index', :as => 'write'

  get 'terms', :to => 'home#terms'
  get 'contact', :to => 'home#contact'
  post 'contact', :to => 'home#contact_submit', :as => 'contact_submit'
  get 'join', :to => 'home#join'
  get 'dashboard', :to => 'home#dashboard'
  get 'about', :to => 'home#about'
  get 'mytutor', :to => 'home#mytutor'

  get 'dev/toolbox', :as => 'dev_toolbox'
  put 'dev/reset_time'
  post 'dev/freeze_time'
  post 'dev/time_travel'
  match 'dev/test_error/:number', :to => 'dev#test_error'
  
  resources :website_configurations, :only => [:index] do
    collection do
      get 'edit'
      put 'update'
    end
  end
  

  match '/', :to => 'home#index', :as => ''
  root :to => "home#index"

end
