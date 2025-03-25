Rails.application.routes.draw do
  # ---------- GLOBAL AUTHENTICATION ROUTES ----------
  devise_for :users, controllers: { sessions: 'users/sessions' }
  
  root "home#index", as: :root
  resources :tenants, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check
  
  # ---------- MAIN COMPANY WEBSITE ROUTES (Root Domain) ----------
  constraints subdomain: '' do
    root 'landings#index', as: :site_root
    resources :landings
    get 'about', to: 'home#about'
    get 'contact', to: 'home#contact'

    # Company Admin Panel
    constraints subdomain: 'admin' do
      namespace :admin do
        root 'dashboard#index', as: :site_admin_root
        resources :users
        resources :subscriptions
        resources :analytics
      end
    end
  end

  # ---------- CUSTOMER-SPECIFIC ROUTES (Subdomains) ----------
  constraints(SubdomainConstraint) do
    root 'tenants#landing', as: :tenant_root

    devise_for :users, controllers: { sessions: 'users/sessions' }, skip: [:registrations], 
              as: :tenant_user

    namespace :admin do
      root 'dashboard#index', as: :tenant_admin_root
      resources :users
      resources :players
      resources :matches
    end
  end

  # ---------- DEFAULT ROUTE (Catch-All) ----------
  get '*path', to: 'errors#not_found', constraints: lambda { |req| req.subdomain.present? }
end
