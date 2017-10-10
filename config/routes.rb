Rails.application.routes.draw do
  #resources :coins
  devise_for :users, :controllers => { omniauth_callbacks: "callbacks", registrations: "registrations"}
  
  resources :users, :only => [:show] do
    resources :wallets
    resources :transactions
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#to_user_show"
  resources :coins, only: [:update]
end
