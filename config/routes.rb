Rails.application.routes.draw do
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
    resources :landings, only: [:index]
    resources :tenants, only: [:index]
    
    authenticate :user do
      get 'dashboard', to: 'dashboard#index', as: :tenant_dashboard
    end
  end

  # ----------------------------------- CATCH-ALL + FALLBACK -
  root to: "home#index", as: :fallback_root
  get '/favicon.ico', to: redirect(ActionController::Base.helpers.asset_path('favicon.png'))
  get '*path', to: 'errors#not_found', constraints: ->(req) { req.subdomain.present? }
end
