AirbnbClone::Application.routes.draw do

  root :to => 'root#root'

  resources :users,    only: [:new, :create, :show] do
    resources :bookings, only: [:index]
  end

  resource  :session,  only: [:new, :create, :destroy]

  resources :spaces,   only: [:new, :create, :show, :index] do
    resources :bookings, only: [:edit, :index]
  end

  resources :bookings, only: [:create, :update, :show] do
    member do
      put "cancel_by_user"
      put "cancel_by_owner"
      put "decline"
      put "book"
      put "approve"
    end
  end

end
