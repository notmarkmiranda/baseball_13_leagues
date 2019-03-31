Rails.application.routes.draw do
  devise_for :user
  root to: 'home#index'

  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

  resources :leagues do
    resources :ownerships
  end

end
