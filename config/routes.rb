# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Ost::Application.routes.draw do

  resources :terp, only: [] do  # can hack the use of the ID to be the quiz ID
    get 'sign_in'
    get 'forgot_password'
    post 'forgot_password'
    post 'reset_password'
    delete 'logout'
    get "sign_up"
    post "sign_up"
    post "register"
    get "solicit_email_confirmation"
    post "confirm_email"
    get 'resend_confirmation_email'
    
    get "consent"
    get "quiz_start"
    get "missing_assignment"
    get "missing_exercises"
    get "too_many_assignments"
    get "my_account"
    get "preview"

    get 'solicit_free_response'
    put 'save_free_response'
    get 'solicit_answer_selection'
    put 'save_answer_selection'
    get 'present_feedback'

    get "quiz_summary"

    get "instructions"
    get "dashboard"
    get "dashboard_consent"
    get "help"
    get 'terms'
    get 'contact_us'
    get "about"
    get "tutorial"
    # get "account_help"
  end


  resources :mail_hooks, :only => [] do
    post 'catch', :on => :collection
  end

  resources :site_licenses  # deprecated

  resources :consent_forms
  resources :consent_options, :only => [:show, :edit, :update]
  
  # 
  # resources :organization_managers
  # resources :researchers
  # 

  get "admin", :to => 'admin#index'
  put "admin/cron", :to => 'admin#cron', :as => "cron"
  get "admin/clone_klass", to: 'admin#clone_klass'
  post "admin/clone_klass", to: "admin#clone_klass"
  get "admin/raise_security_transgression", :to => 'admin#raise_security_transgression'
  get "admin/raise_record_not_found",       :to => 'admin#raise_record_not_found'
  get "admin/raise_routing_error",          :to => 'admin#raise_routing_error'
  get "admin/raise_unknown_controller",     :to => 'admin#raise_unknown_controller'
  get "admin/raise_unknown_action",         :to => 'admin#raise_unknown_action'
  get "admin/raise_missing_template",       :to => 'admin#raise_missing_template'
  get "admin/raise_not_yet_implemented",    :to => 'admin#raise_not_yet_implemented'
  get "admin/raise_illegal_argument",       :to => 'admin#raise_illegal_argument'

  get "research", :to => 'research#index'

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
    resources :students, :shallow => true, :only => [:index, :show, :update, :edit]
    resources :sections, :shallow => true
    resources :external_assignments, :shallow => true, :except => [:new, :edit, :update] do
      post 'sort', :on => :collection
      get  'show_table',   :on => :member
      put  'update_table', :on => :member
      get  'report',       :on => :collection
      resources :external_assignment_exercises, :shallow => true, :only => [:create] do
        post 'sort', :on => :collection
      end
    end
    resources :registration_requests, :shallow => true, :only => [:new, :index]
    resources :learning_conditions, :shallow => true, :only => [:index]
    resources :cohorts, :shallow => true
    resources :analytics, :only => [:index]
    get 'preview_assignments', :on => :member
    get 'report', :on => :member
    get 'class_grades', :on => :member
    get 'management_overview', :on => :member
  end

  resources :assignment_exercises, :only => [:show]

  resources :external_assignments, :shallow => true, :only => [ ] do
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
  end

  resources :external_assignment_exercises, :shallow => true, :only => [:destroy] do
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
  end

  resources :student_external_assignments, :shallow => true, :only => [ ] do
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
  end

  resources :student_external_assignment_exercises, :shallow => true, :only => [ ] do
    collection do
      put :update_attribute_on_the_spot
      get :get_attribute_on_the_spot
    end
  end

  resources :learning_conditions, :only => [] do
    resources :schedulers, :shallow => true, :except => [:index, :show, :destroy]
    resources :learning_condition_presentation_conditions, :shallow => true, :except => [:index, :show] do
      post 'sort', :on => :collection
    end
    resources :learning_condition_feedback_conditions, :shallow => true, :except => [:index, :show] do
      post 'sort', :on => :collection
    end
  end

  resources :learning_condition_default_presentation_conditions, only: [ :edit, :update ]
  resources :learning_condition_default_feedback_conditions,     only: [ :edit, :update ]

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
      
  resources :learning_plans, :only => [:show, :edit, :update] do
    resources :topics, :shallow => true, :except => [:new, :index, :show]
    resources :assignment_plans, :shallow => true
    resources :concepts, :shallow => true do
      post 'sort', :on => :collection
    end
    put 'refresh_exercises'
  end
  
  resources :assignment_plans do
    resources :assignment_plan_topics, :shallow => true, :only => [:new, :create, :destroy, :update]
  end
  
  resources :assignments, :only => [:show] do
    get 'grades', :on => :member
  end
  
  resources :topics, :only => [] do
    resources :resources, :shallow => true, :except => [:index, :show] do
      post 'sort', :on => :collection
    end
    resources :topic_exercises, :shallow => true, :except => [:index, :show] do
      post 'sort', :on => :collection
    end
  end
    
  resources :response_times, :only => [:create]

  resources :student_assignments, :only => [:show] do
    resources :assignment_coworkers, :shallow => true, :only => [:new, :create, :destroy] do
      collection do
        post 'search'
      end
    end
  end
  
  resources :student, :only => [] do
    resources :student_assignments, :only => [:index]
    resources :consents, :shallow => true, :except => [:index, :show, :edit, :update, :destroy]
  end

  resources :student_exercises, :only => [:show, :update] do
    get 'feedback'
    put 'make_correct'
    get 'score_detail'
    resources :free_responses, :shallow => true, :except => [:index, :show] do
      post 'sort', :on => :collection
      get 'email_instructions', :on => :collection
      get 'refresh', :on => :collection
    end
  end

  resources :text_free_responses, :only => [] do
    get 'preview', :on => :collection
  end

  resources :file_free_responses, :only => [] do
    get 'view', :on => :member
  end

  
  # For users, we mix devise with our own users controller.  We have overriden
  # some devise controller methods, so point that out here.
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions", :confirmations => "confirmations"}

  resources :users, :only => [:index, :show, :edit, :update] do
    post 'become'
    put 'confirm'
  end

  post "write", :to => 'write#index', :as => 'write'

  mount FinePrint::Engine => "/fine_print"

  get 'terms', :to => 'home#terms'
  get 'contact', :to => 'home#contact'
  post 'contact', :to => 'home#contact_submit', :as => 'contact_submit'
  get 'join', :to => 'home#join'
  get 'dashboard', :to => 'home#dashboard'
  get 'about', :to => 'home#about'
  get 'mytutor', :to => 'home#mytutor'
  get 'help', :to => 'help#index'
  
  get 'help/blurbs/:blurb_name', :to => 'help#blurb', :as => 'blurb_help'
  match 'help/faq'
  match 'help/student_getting_started'
  match 'help/assignments'
  match 'help/topics'
  match 'help/scheduling'
  match 'help/instructor_getting_started'
  match 'help/learning_conditions'
  match 'help/class_settings'
  match 'help/student_tutorials'
  match 'help', :to => 'help#index'
  match 'help/instructor_faq'
  
  get "terms/:id/show", to: "terms#show", as: "show_terms"
  get "terms/pose", to: "terms#pose", as: "pose_terms"
  post "terms/agree", to: "terms#agree", as: "agree_to_terms"

  get 'dev/toolbox', :as => 'dev_toolbox'
  put 'dev/reset_time'
  post 'dev/freeze_time'
  post 'dev/time_travel'
  post 'dev/run_cron_tasks'
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
