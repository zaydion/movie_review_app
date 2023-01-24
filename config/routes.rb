Rails.application.routes.draw do
  root "movies#index"

  resources :characterizations
  resources :genres

  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  resource :session, only: [:new, :create, :destroy]
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"

  resources :users
  get "signup", to: "users#new"

  get "movies/filter/:filter", to: "movies#index", as: :filtered_movies
end
