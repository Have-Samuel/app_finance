Rails.application.routes.draw do
  resource :registration
  resources :accounts do
    # Nest the routes so transactions belong to an account.
    resources :transactions, only: [ :create, :destroy ]
  end
  resource :session
  resources :passwords, param: :token
  get "up" => "rails/health#show", as: :rails_health_check

  root "accounts#index"
  get "/dashboard", to: "accounts#dashboard"
end
