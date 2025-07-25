Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  resources :routers do 
    member do
      get :fetch_router_data
    end

    resources :stations
    resources :hotspot_profiles
  end
  
  resources :sessions, only: [:new, :create] do 
    collection do 
      get :logout
    end
  end





  resources :vouchers, only: [ :index, :create ]
  resources :events, only: [ :create ]
  resources :stations
  resources :login_counters, only: [ :create ]
end
