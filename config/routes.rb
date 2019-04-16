Rails.application.routes.draw do
  devise_for :user
  root to: 'home#index'

  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

  resources :leagues, param: :token do
    resources :ownerships do
      member do
        patch 'mark-as-paid', to: 'paid#paid'
        patch 'mark-as-unpaid', to: 'paid#unpaid'
      end
    end
  end

end
