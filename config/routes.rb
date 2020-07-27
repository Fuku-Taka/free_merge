Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get  'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end

  root 'contents#index'
  
  resources :users, only: [:show, :edit, :update]

  resources :contents do
    member do
      post 'purchase'
      get 'purchased'
      get 'buy'
      get 'reserve'
      patch 'reserved'
      patch 'reserve_cancel'
    end
  end
  resources :cards, only: [:show]
  resources :categories, only: [:index, :show]
end
