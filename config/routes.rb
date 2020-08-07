Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get  'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end

  root 'contents#index'
  
  resources :users, only: [:show, :edit, :update] do
    member do
      get 'logout'
    end
  end

  resources :contents do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    member do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
      post 'purchase'
      get 'purchased'
      get 'buy'
      get 'reserve'
      patch 'reserved'
      patch 'reserve_cancel'
    end
  end

  resources :cards, only: [:show, :new, :index, :create, :destroy]
  resources :categories, only: [:index, :show]
end
