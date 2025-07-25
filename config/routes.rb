Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files (commented out for now)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root path
  root "dashboard#index"

  # Authentication routes
  resources :sessions, only: [:new, :create] do 
    collection do 
      delete :logout
    end
  end

  # Router management with nested resources
  resources :routers do 
    member do
      get :fetch_router_data
    end

    # Nested station resources under routers
    resources :stations, except: [:index] do
      resources :vouchers, only: [:new, :create]
    end
    
    # Nested hotspot profile resources under routers
    resources :hotspot_profiles, except: [:index, :show] do
      member do
        post :sync
      end
    end
  end
  
  # Independent station routes (for listing all stations)
  resources :stations, only: [:index, :show]
  
  # Voucher management
  resources :vouchers do
    member do
      patch :collect
      patch :uncollect
    end
    
    collection do
      post :process_code
    end
  end
  
  # Event management
  resources :events, only: [:index, :show, :create]
  
  # Login counters (analytics)
  resources :login_counters, only: [:index, :create]

  # API routes
  namespace :api do
    namespace :v1 do
      resources :vouchers, only: [:show, :create] do
        collection do
          post :process
        end
      end
    end
  end
end
