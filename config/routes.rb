Rails.application.routes.draw do
  root "movies#index"

  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  resource :session, only: [:new, :create, :destroy]
  get 'signin' => 'sessions#new'
  delete 'signout' => 'sessions#destroy'

  resources :users
  get 'signup' => 'users#new'
end
