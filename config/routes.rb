Ost::Application.routes.draw do

  devise_for :users

  get 'dev/toolbox', :as => 'dev_toolbox'
  put 'dev/reset_time'
  post 'dev/freeze_time'
  post 'dev/time_travel'

  match '/', :to => 'home#index', :as => ''
  root :to => "home#index"

end
