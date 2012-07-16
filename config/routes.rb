Ost::Application.routes.draw do

  

  get "catalog", :to => 'catalog#index'

  resources :organizations do
    resources :courses, :shallow => true
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
