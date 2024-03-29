Rails.application.routes.draw do
  resources :beer_clubs
  resources :memberships, only: [:index, :create, :delete]
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :show]
  delete 'ratings', to: 'ratings#destroy'
  resources :places, only: [:index, :show]
  resource :session, only: [:new, :create, :destroy]
  resource :membership, only: [:delete]
  resources :styles do
    get 'about', on: :collection
  end
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :users do
    post 'toggle_account', on: :member
    get 'recommendations', on: :member
  end
  resources :memberships do
    post 'confirm', on: :member
  end

  
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
  delete 'membership', to: 'memberships#destroy'
  get 'beerlist', to:'beers#list'
  get 'calculator', to: "misc#calculator"
end
