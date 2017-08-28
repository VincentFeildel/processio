Rails.application.routes.draw do
  resources :events, only: [:index, :show, :update] do
    get 'letter', to: 'events#letter'
    post 'mail', to: 'events#mail'
    resources :comments
  end
  resources :leases, only: [:new, :index]

  devise_for :users
  root to: 'pages#home'

  get 'urgent_events', to: 'events#index_urgent'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
