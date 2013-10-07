AirbnbClone::Application.routes.draw do

  root :to => 'root#root'

  resources :users,    only: [:new, :create, :show] do
    resources :bookings, only: [:index]
  end

  resource  :session,  only: [:new, :create, :destroy]

  resources :spaces,   only: [:new, :create, :show, :index] do
    resources :bookings, only: [:new, :index]
  end

  resources :bookings, only: [:create, :show]

end
