Ost::Application.routes.draw do

  

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

  resources :learning_plans

  resources :registration_requests

  resources :researchers

  resources :students

  resources :cohorts

  resources :sections

  resources :educators

  resources :offered_courses

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
  end

  devise_for :users

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
