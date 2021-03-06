Ratebeer::Application.routes.draw do
  resources :styles

  root 'breweries#index'

  resources :memberships do
    post 'toggle_confirmation', on: :member
  end

  resources :beer_clubs

  resources :users

  resources :beers

  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :ratings, only: [:index, :new, :create, :destroy]

  resources :sessions, only: [:new, :create]

  resources :places, only: [:index, :show]

  post 'places', to: 'places#search'

  get 'kaikki_bisset', to: 'beers#index'

  get 'signup', to: 'users#new'

  get 'signin', to: 'sessions#new'

  delete 'signout', to: 'sessions#destroy'
  #get 'signout', to: 'sessions#destroy'

  get 'beerlist', to: 'beers#list'
  get 'ngbeerlist', to: 'beers#nglist'
  get 'brewerylist', to: 'breweries#list'
end
