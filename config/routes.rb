AirbnbClone::Application.routes.draw do

  root :to => 'root#root'

  resources :users,    only: [:new, :create, :show]

  resource  :session,  only: [:new, :create, :destroy] do
    member do
      put "guest_user_sign_in"
    end
  end

  resources :spaces,   only: [:new, :create, :show, :index] do
    resources :bookings, only: [:edit, :index]
  end

  resources :bookings, only: [:index, :create, :show] do
    member do
      put "cancel_by_user"
      put "cancel_by_owner"
      put "decline"
      put "book"
      put "approve"
    end
  end

  resources :user_photos, only: [:index] do
    member do
      put "ban"
      put "unban"
    end
  end

  resources :space_photos, only: [:index] do
    member do
      put "ban"
      put "unban"
    end
  end

end
