Rails.application.routes.draw do
  resources :beer_clubs
  resources :memberships, only: [:index, :create]
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :places, only: [:index, :show]
  resource :session, only: [:new, :create, :destroy]

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'breweries#index'
  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'new_membership', to: 'memberships#new'
  post 'membership', to: 'memberships#create'
  get 'places', to: 'places#index'
  post 'places', to: 'places#search'
end
