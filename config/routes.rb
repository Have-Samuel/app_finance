Rails.application.routes.draw do
  resource :registration
  resources :accounts
  resource :session
  resources :passwords, param: :token
  get "up" => "rails/health#show", as: :rails_health_check

  root "accounts#index"
end
