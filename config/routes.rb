Rails.application.routes.draw do
  # ---------- GLOBAL AUTHENTICATION ROUTES ----------
  devise_for :users, controllers: { sessions: 'users/sessions' }, skip: [:registrations]

  get "up" => "rails/health#show", as: :rails_health_check
  
  # ---------- MAIN COMPANY WEBSITE ROUTES (Root Domain) ----------
  constraints(lambda { |req| req.subdomain.blank? || req.subdomain == "www" }) do
    root to: "home#index", as: :main_root

    get 'about', to: 'home#about'
    get 'contact', to: 'home#contact'
  end

# ---------- SUPERADMIN SECTION (Admin Panel via admin.mykos.shop) ----------
constraints(lambda { |req| req.subdomain == 'admin' }) do
  namespace :admin do
    root to: "dashboard#index", as: :superadmin_root
    resources :tenants
    resources :users
    resources :plans
    # Add more as needed
  end
end

  # ---------- TENANT LANDINGS ----------
  constraints(SubdomainConstraint) do
    root to: "landings#index", as: :tenant_root

    resources :landings, only: [:index]
    resources :tenants, only: [:index]

    # Authenticated User Dashboard (all roles)
    namespace :dashboard do
      root to: "dashboard#index", as: :tenant_dashboard_root
      resources :profile, only: [:index, :edit, :update]
    end
  end

  # ---------- DEFAULT ROUTE (Catch-All) ----------
  root "home#index", as: :root
  get '/favicon.ico', to: redirect(ActionController::Base.helpers.asset_path('favicon.png'))
  get '*path', to: 'errors#not_found', constraints: lambda { |req| req.subdomain.present? }
end
