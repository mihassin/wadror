Ratebeer::Application.routes.draw do
  resources :beers

  resources :breweries
  
  resources :ratings, only: [:index, :new, :create, :destroy]

  root 'breweries#index'

  get 'kaikki_bisset', to: 'beers#index'
end
