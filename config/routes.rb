Rails.application.routes.draw do
  mount ActiveStorage::Engine => "/rails/active_storage"
  # ------------------------------------ GLOBAL AUTH ROUTES -
  devise_for :users, controllers: { sessions: 'users/sessions' }, skip: [:registrations]

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # -------------------------------------- MAIN PUBLIC SITE -
  constraints(lambda { |req| req.subdomain.blank? || req.subdomain == "www" }) do
    root to: "home#index", as: :main_root
    get 'susudio', to: 'home#susudio'
    get 'kamaly', to: 'home#kamaly'
    get 'contact', to: 'home#contact'
  end

  # -------------------------------------- SUPERADMIN PANEL -
  constraints(lambda { |req| req.subdomain == "admin" }) do
    namespace :admin do
      root to: "dashboard#index", as: :superadmin_root
      resources :tenants
      resources :users
    end
  end

  # ------------------- TENANT PUBLIC LANDING + AUTH ROUTES -
  constraints(SubdomainConstraint) do
    root to: "landings#index", as: :tenant_root      
    authenticate :user do
      get 'dashboard', to: 'dashboard#index', as: :tenant_dashboard
      get 'show-test', to: 'dashboard#show', as: :tenant_show_dashboard
      resources :schools
      resources :categories do
        resources :matches, only: [:index]
        resources :call_ups, only: [:index, :new, :edit, :update ]
        resources :training_sessions, only: [:index]
      end
      resources :players do
        resource :player_profile, only: [:new, :create, :show, :edit, :update]
        resources :guardians, only: [:new, :create, :edit, :update, :destroy]
        post :documents, on: :member
        member do
          get :select_category
          post :assign_category
          get :teammates
          delete 'remove_category'
          delete 'documents/:blob_id', to: 'players#erase_document', as: :erase_document
        end
      end
      resources :tournaments
      resources :call_ups, only: [:new, :create, :edit, :update]
      resources :matches, only: [:new, :create, :show, :index, :update] do
        resources :line_ups, only: [:index, :new, :create, :edit, :update ]
        resources :match_reports
        patch :update_performances, on: :member
      end
      resources :coaches do
        member do
          get :assistants           # admin/coaches/:id/assistants
          post :assign_assistant    # admin/coaches/:id/assign_assistant
          delete 'remove_assistant/:assistant_id', to: 'coaches#remove_assistant', as: :remove_assistant
        end
      end
      resources :events do
        collection do
          get :calendar
        end
      end
      get 'assistants', to: 'assistants#index', as: :assistants
      post 'assistants/assign_coach', to: 'assistants#assign_coach', as: :assign_coach_to_assistant
      delete 'assistants/remove_coach', to: 'assistants#remove_coach', as: :remove_coach_from_assistant
      get 'assistants/:id/edit', to: 'assistants#edit', as: :edit_assistant
      patch 'assistants/:id', to: 'assistants#update', as: :assistant

      resources :sites
      resources :training_sessions do
        resources :training_attendances, only: [:index, :new, :create, :edit, :update]
      end
      resources :publications
      resources :incomes
      resources :expenses
      resources :exonerations
      resources :users
      resources :category_team_assistants, only: [:new, :create, :destroy]
    end
  end

  # ----------------------------------- CATCH-ALL + FALLBACK -
  root to: "home#index", as: :fallback_root
  get '/keepalive', to: 'application#keepalive'
  get '/favicon.ico', to: redirect('/assets/favicon.png')
  get '*path', to: 'errors#not_found', constraints: ->(req) {
    req.subdomain.present? && !req.path.start_with?('/rails/active_storage')
  }
end
