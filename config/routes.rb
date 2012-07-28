Ost::Application.routes.draw do

  

  resources :learning_conditions

  resources :consent_forms

  resources :organization_managers

  resources :student_exercises

  resources :assignment_exercises

  resources :student_assignments

  resources :topic_exercises

  resources :resources

  resources :assignment_topics

  resources :assignments

  resources :exercises

  resources :topics

  resources :concepts

  resources :researchers

  resources :students

  resources :educators

  get "admin", :to => 'admin#index'



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
    resources :educators, :shallow => true, :only => [:new, :create, :destroy] do
      collection do
        post 'search'
      end
    end
    resources :students, :shallow => true, :only => [:index, :show, :update]    
    resources :sections, :shallow => true
  end
  
  # resources :offered_courses, :only => :index do
  #   resources :educators, :shallow => true, :only => [:new, :create, :destroy] do
  #     collection do
  #       post 'search'
  #     end
  #   end
  #   resources :students, :shallow => true, :only => [:index, :show, :update]
  # end
  
  resources :sections, :only => [] do
    resources :registration_requests, :shallow => true, :only => [:index, :create, :destroy]
    resources :cohorts, :shallow => true
  end
  
  resources :learning_plans

  # For users, we mix devise with our own users controller.  We have overriden
  # some devise controller methods, so point that out here.
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users, :only => [:index, :show, :edit, :update] do
    post 'become'
  end


  get 'terms', :to => 'home#terms'
  get 'contact', :to => 'home#contact'
  post 'contact', :to => 'home#contact_submit', :as => 'contact_submit'
  get 'join', :to => 'home#join'

  get 'dev/toolbox', :as => 'dev_toolbox'
  put 'dev/reset_time'
  post 'dev/freeze_time'
  post 'dev/time_travel'
  
  resources :website_configurations, :only => [:index] do
    collection do
      get 'edit'
      put 'update'
    end
  end
  

  match '/', :to => 'home#index', :as => ''
  root :to => "home#index"

end
