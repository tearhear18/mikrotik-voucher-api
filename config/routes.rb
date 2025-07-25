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
      post :test_connection
    end

    resources :stations do
      resources :vouchers, only: [:index, :new, :create]
    end
    resources :hotspot_profiles do
      member do
        post :create_on_router
      end
      collection do
        post :sync
      end
    end
  end
  
  resources :sessions, only: [:new, :create] do 
    collection do 
      get :logout
    end
  end

  resources :vouchers, only: [:index, :create] do
    member do
      patch :collect
      patch :uncollect
    end
    
    collection do
      post :process_code
    end
  end
  
  resources :events, only: [:create]
  resources :stations, only: [:index]
  resources :login_counters, only: [:create]

  # API routes
  namespace :api do
    namespace :v1 do
      resources :vouchers, only: [:create, :show] do
        collection do
          post :process
        end
      end
      resources :stations, only: [:index, :show]
      resources :routers, only: [:index, :show]
    end
  end
end
