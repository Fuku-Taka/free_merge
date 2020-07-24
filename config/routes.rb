Rails.application.routes.draw do
  root 'contents#show'
  
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
