Rails.application.routes.draw do
  resources :events, only: [:index, :show] do
    get 'owner_contacted', to: "events#owner_contacted"
  end
  resources :leases, only: [:new, :index]

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
